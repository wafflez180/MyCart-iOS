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
        brandLabel.text = product?.brand!
        quantityLabel.text = "1 x "
        priceLabel.text = String(describing: product?.price!)
    }
    
    // MARK: Actions
    
    @IBAction func onDecreaseButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func onIncreaseButtonClick(_ sender: UIButton) {
    }

}
