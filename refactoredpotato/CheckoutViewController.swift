//
//  CheckoutViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class CheckoutViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    // MARK: Properties
    
    @IBOutlet weak var productImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var previewImageView: UIImageView!
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var productsInCart = [Product]()
    var isCheckingProduct = false
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        productsTableView.dataSource = self
        productsTableView.delegate = self
    
        tableViewWidthConstraint.constant = UIScreen.main.bounds.size.width * 0.60
        
        // Create a session object.
        session = AVCaptureSession()
        
        // Set the captureDevice.
        
        var videoCaptureDevice : AVCaptureDevice?
        let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in (captureDevices)!
        {
            //Change position to front for front-facing camera
            if (device as! AVCaptureDevice).position == AVCaptureDevicePosition.back
            {
                videoCaptureDevice = device as? AVCaptureDevice
            }
        }
        
        // Create input object.
        let videoInput: AVCaptureDeviceInput?
        
        do
        {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch
        {
            return
        }
        
        // Add input to the session.
        if (session.canAddInput(videoInput))
        {
            session.addInput(videoInput)
        }
        else
        {
            scanningNotPossible()
        }
        
        // Create output object.
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        if (session.canAddOutput(metadataOutput))
        {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
            
        }
        else
        {
            scanningNotPossible()
        }
        
        // Add previewLayer and have it show the video data.
        
        let bounds = previewImageView.bounds
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = previewImageView.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.bounds = bounds;
        previewLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        previewImageView.layer.addSublayer(previewLayer)
        previewImageView.layoutIfNeeded()
        
        // Begin the capture session.
        
        session.startRunning()
        
        // Greet the customer
        saySomething(message: "Good afternoon, welcome to my shop. Please scan your items.")
        
        // TEST check an item
        //checkProduct(barcode: "0078742040370_FUCK")
        
        //Test Product
        /*
        let testProduct = Product(barcode: "234", name: "bullshit", brand: "test", price: 1.00)
        productsInCart+=[testProduct!]
        DispatchQueue.main.async{
            self.productsTableView.reloadData()
        }
        */
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changedProductQuantity),
            name: NSNotification.Name(rawValue: "ChangedQuantity"),
            object: nil)

        
        updateSubtotal()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (session?.isRunning == false)
        {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true)
        {
            session.stopRunning()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    public override func viewWillLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

        previewLayer?.frame = previewImageView.layer.bounds
    }
    
    // MARK: AVCapture Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        // Get the first object from the metadataObjects array.
        if let barcodeData = metadataObjects.first
        {
            // Turn it into machine readable code
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            if let readableCode = barcodeReadable
            {
                // Send the barcode as a string to barcodeDetected()
                barcodeDetected(code: readableCode.stringValue);
            }
            
            // Avoid a very buzzy device.
            //Removed
            //session.stopRunning()
        }
    }
    
    // MARK: CheckoutViewController
    
    func scanningNotPossible()
    {
        // Let the user know that scanning isn't possible with the current device.
        /*let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        session = nil*/
    }
    
    func barcodeDetected(code: String)
    {
        if (isCheckingProduct)
        {
            return
        }
        
        let trimmedCode = code.trimmingCharacters(in: .whitespaces)
        checkProduct(barcode: trimmedCode)
    }
    
    func checkProduct(barcode: String)
    {
        isCheckingProduct = true
    
        Alamofire.request(Constants.API.ADDRESS + Constants.API.CALL_GET_PRODUCT + barcode)
        .responseJSON()
        {
            response in
            //debugPrint(response)
            
            let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.resetIsCheckingProduct), userInfo: nil, repeats: false);
            
            switch response.result
            {
                case .success(let responseData):
                    let json = JSON(responseData);

                    if let error = json["error"].string
                    {
                        print("ERROR: \(error)")
                        return
                    }

                    if let newProduct : Product = Product(json: json)
                    {
                        AudioServicesPlaySystemSound(1206)
                        
                        // Vibrate the device to give the user some feedback.
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        self.addProductToCart(newProduct: newProduct)
                        
                        //let alert = UIAlertController(title: "Product scanned!", message: newProduct.name!, preferredStyle: UIAlertControllerStyle.alert)
                        //self.present(alert, animated: true, completion: nil)
                    }
                    
                    return
                
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    return
            }
        }
    }
    
    func addProductToCart(newProduct: Product)
    {
        if productIsInCart(scannedProduct: newProduct)
        {
            increaseProductQuantity(scannedProduct: newProduct)
        }else
        {
            saySomething(message: newProduct.name!)
            productsInCart+=[newProduct]
        }
        DispatchQueue.main.async{
            self.productsTableView.reloadData()
        }
        updateSubtotal()
    }
    
    func resetIsCheckingProduct()
    {
        isCheckingProduct = false
    }
    
    func updateSubtotal(){
        if productsInCart.count > 0
        {
            var subtotal = 0.0 as Float
            for product in productsInCart
            {
                subtotal+=(product.price! * Float(product.quantity!))
            }
            let tempSubtotal = String(format: "%.2f", subtotal)
            subtotalLabel.text = "Subtotal (\(productsInCart.count) items): $\(tempSubtotal)"
        }else{
            subtotalLabel.text = "Subtotal (0 items): $0.00"
        }
    }
    
    @objc func changedProductQuantity(notification: NSNotification){
        updateSubtotal()
    }
    
    func productIsInCart(scannedProduct: Product) -> Bool
    {
        for product in productsInCart
        {
            if product.barcode == scannedProduct.barcode
            {
                return true
            }
        }
        return false
    }
    
    func increaseProductQuantity(scannedProduct: Product){
        for productCell in productsTableView.visibleCells
        {
            let cell = productCell as! ProductTableViewCell
            if scannedProduct.barcode == cell.product?.barcode
            {
                cell.increaseQuantity()
            }
        }
    }
    
    func saySomething(message: String)
    {
        let parameters : Parameters = ["text" : message, "voice" : "Dawn Happy"]
        let headers: HTTPHeaders = [
        "apikey": "5a34fd9150ad4c3d9f75efce01aa493f",
        "Content-Type": "application/json"
        ]

        Alamofire.request(Constants.API.CALL_GET_VOICE, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .responseData()
        {
            response in
            
            switch response.result
            {
                case .success(let responseData):
                    self.audioPlayer = try? AVAudioPlayer(data: responseData, fileTypeHint: AVFileTypeWAVE)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.volume = 0.5
                    self.audioPlayer?.play()
                    
                    return
                
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    return
            }
        }
    }
    
    // MARK: TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductTableViewCell
        let product = productsInCart[indexPath.row]
        cell.setLabels(newProduct: product)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.cornerRadius = 25
        
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        
        // Download the image
        Alamofire.request(product.imageUrl!).responseImage
        {
            response in
            
            if let image = response.result.value
            {
                print("image downloaded: \(image)")
                cell.productImageView!.image = response.result.value
                
                cell.productImageView.contentMode = UIViewContentMode.scaleAspectFit
                self.productImageViewWidthConstraint.constant = cell.frame.size.width * 0.35
                //cell.layoutSubviews()
                cell.setNeedsLayout()
                cell.updateConstraints()
            }
        }
        
        return cell
    }

    // MARK: Actions
    
    @IBAction func onManageButtonClick(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "manageSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
