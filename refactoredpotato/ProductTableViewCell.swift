//
//  ProductTableViewCell.swift
//  refactoredpotato
//
//  Created by Arthur De Araujo on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var product : Product?

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabels(newProduct: Product)
    {
        product = newProduct
        
        nameLabel.text = product?.name!
        brandLabel.text = "By \(product!.brand!)"
        quantityLabel.text = "\(product!.quantity!) x "
        let price = (product?.price!)! * Float((product?.quantity!)!)
        priceLabel.text = "$" + String(format: "%.2f", price)
    }
    
    func increaseQuantity(){
        product!.quantity!+=1
        quantityLabel.text = "\(product!.quantity!) x "
        let price = (product?.price!)! * Float((product!.quantity!))
        priceLabel.text = "$" + String(format: "%.2f", price)
    }
    
    func decreaseQuantity(){
        if product!.quantity! > 1
        {
            product!.quantity!-=1
            quantityLabel.text = "\(product!.quantity!) x "
            let price = (product?.price!)! * Float((product!.quantity!))
            priceLabel.text = "$" + String(format: "%.2f", price)
        }else
        {
            //Give alert "Are you sure?" and then delete product
        }
    }
    
    // MARK: Actions
    
    @IBAction func onDecreaseButtonClick(_ sender: UIButton)
    {
        decreaseQuantity()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangedQuantity"), object: nil)
    }
    
    @IBAction func onIncreaseButtonClick(_ sender: UIButton)
    {
        increaseQuantity()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangedQuantity"), object: nil)
    }

}
