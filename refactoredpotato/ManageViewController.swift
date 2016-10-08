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

class ManageViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        retrieveProducts()
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
            
            switch response.result
            {
                case .success(let responseData):
                    let json = JSON(data: responseData);
                    return
                
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    return
            }
        }
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
