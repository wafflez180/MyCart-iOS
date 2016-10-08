//
//  CheckoutViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit
import AVFoundation

class CheckoutViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    @IBOutlet weak var previewImageView: UIImageView!
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        // Create a session object.
        session = AVCaptureSession()
        
        // Set the captureDevice.
        
        var videoCaptureDevice : AVCaptureDevice?
        let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in (captureDevices)! {
            //Change position to front for front-facing camera
            if (device as! AVCaptureDevice).position == AVCaptureDevicePosition.back {
                videoCaptureDevice = device as? AVCaptureDevice
            }
        }
        
        // Create input object.
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // Add input to the session.
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // Create output object.
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
            
        } else {
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
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (session?.isRunning == false)
        {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true) {
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Get the first object from the metadataObjects array.
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            if let readableCode = barcodeReadable {
                // Send the barcode as a string to barcodeDetected()
                barcodeDetected(code: readableCode.stringValue);
            }
            
            // Vibrate the device to give the user some feedback.
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device.
            session.stopRunning()
        }
    }
    
    // MARK: Custom Funcs
    
    func scanningNotPossible() {
        // Let the user know that scanning isn't possible with the current device.
        /*let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        session = nil*/
    }
    
    func barcodeDetected(code: String) {
        
        // Let the user know we've found something.
        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.destructive, handler: { action in
            
            // Remove the spaces.
            let trimmedCode = code.trimmingCharacters(in: .whitespaces)
            
            // EAN or UPC?
            // Check for added "0" at beginning of code.
            
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String
            
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())

                // Send the doctored UPC to DataService.searchAPI()
                
                //IMPLEMENT BACKEND HERE
                
                //DataService.searchAPI(trimmedCodeNoZero)
            } else {
                
                // Send the doctored EAN to DataService.searchAPI()
                
                //IMPLEMENT BACKEND HERE

                //DataService.searchAPI(trimmedCodeString)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
