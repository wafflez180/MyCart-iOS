//
//  ManageViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ManageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var mainTopInfoBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainProductAnalyticWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var averageAgeLabel: UILabel!
    @IBOutlet weak var popularGenderLabel: UILabel!
    @IBOutlet weak var popularRaceLabel: UILabel!
    @IBOutlet weak var smileAverageLabel: UILabel!
    @IBOutlet weak var mainProductQuantityLabel: UILabel!
    @IBOutlet weak var mainProductBrandLabel: UILabel!
    @IBOutlet weak var mainProductImageView: UIImageView!
    @IBOutlet weak var mainProductNameLabel: UILabel!
    
    var productsInStock = [Product]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainProductAnalyticWidthConstraint.constant = UIScreen.main.bounds.size.width * 0.70
        mainTopInfoBarHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.30
        retrieveProducts()
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //Test Product
        let testProduct = Product(barcode: "234", name: "bullshit", brand: "test", price: 1.00)
        productsInStock+=[testProduct!]
        DispatchQueue.main.async{
            self.productsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveProducts()
    {
        Alamofire.request(Constants.API.ADDRESS + Constants.API.CALL_GET_PRODUCTS)
        .responseJSON()
        {
            response in
            debugPrint(response)
            switch response.result
            {
                case .success(let responseData):
                    let json = JSON(responseData);
                    let productsJSON = json["products"].array
                    
                    for subJSON in productsJSON!
                    {
                        if let newProduct : Product = Product(json: subJSON)
                        {
                            print("Got product: \(newProduct.name!)")
                            self.productsInStock+=[newProduct]
                        }
                    }
                    
                    DispatchQueue.main.async{
                        self.productsTableView.reloadData()
                    }
                    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsInStock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageProductCell", for: indexPath) as! ManageProductTableViewCell
        cell.setLabels(newProduct: productsInStock[indexPath.row])
        
        if indexPath.row == 0
        {
            cell.setSelected(true, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.tintColor = UIColor.white
        cell.brandLabel.tintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        
        print(cell.nameLabel.text)
        
        var extensionFrame = cell.frame
        extensionFrame.origin.x=cell.frame.size.width + cell.frame.origin.x
        let cellExtension = UIView(frame: extensionFrame)
        cellExtension.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        cell.addSubview(cellExtension)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.tintColor = UIColor(red:0.01, green:0.01, blue:0.01, alpha:1.0)
        cell.brandLabel.tintColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
        cell.backgroundColor = UIColor.white
        
        for subView in cell.subviews
        {
            if subView.frame.origin.x == (cell.frame.size.width + cell.frame.origin.x)
            {
                subView.removeFromSuperview()
            }
        }
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.tintColor = UIColor.white
        cell.brandLabel.tintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        
        print(cell.nameLabel.text)
        
        var extensionFrame = cell.frame
        extensionFrame.origin.x=cell.frame.size.width + cell.frame.origin.x
        let cellExtension = UIView(frame: extensionFrame)
        cellExtension.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        cell.addSubview(cellExtension)
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func increaseStock(_ sender: UIButton) {
    }
    
    @IBAction func decreaseStock(_ sender: UIButton) {
    }

}
