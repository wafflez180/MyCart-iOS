//
//  ProductTableViewCell.swift
//  refactoredpotato
//
//  Created by Arthur De Araujo on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
