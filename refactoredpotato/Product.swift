//
//  Product.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product
{
    var barcode : String?
    var name : String?
    var brand : String?
    var price : Float?
    var quantity : Int?
    var imageUrl : String?

    init?(barcode : String?, name : String?, brand : String?, price : Float?, imageUrl : String?)
    {
        self.barcode = barcode
        self.name = name
        self.brand = brand
        self.price = price
        self.quantity = 1
        self.imageUrl = imageUrl
        
        print("Created Product \(name!), price \(price!)")
    }
    
    convenience init?(json : JSON)
    {
        let newBarcode = json["barcode"].string
        let newName = json["name"].string
        let newBrand = json["brand"].string
        let newPrice = json["price"].float
        //let newImageUrl = json["image_url"].string
        let newImageUrl = "http://i.imgur.com/VamlAl4.png"
        
        self.init(barcode: newBarcode, name: newName, brand: newBrand, price: newPrice, imageUrl : newImageUrl)
    }
}
