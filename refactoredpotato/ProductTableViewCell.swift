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

    var product : Product?

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
