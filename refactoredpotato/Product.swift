//
//  Product.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import Foundation

class Product
{
    var id : Int
    var barcode : String
    var name : String
    var brand : String
    var price : Int

    init?(id : Int, barcode : String, name : String, brand : String, price : Int)
    {
        self.id = id
        self.barcode = barcode
        self.name = name
        self.brand = brand
        self.price = price
    }
}
