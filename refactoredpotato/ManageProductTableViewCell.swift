//
//  ManageProductTableViewCell.swift
//  refactoredpotato
//
//  Created by Arthur De Araujo on 10/9/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit

class ManageProductTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var product : Product?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabels(newProduct: Product)
    {
        product = newProduct
        
        nameLabel.text = product?.name!
        brandLabel.text = "By \(product!.brand!)"
    }


}
