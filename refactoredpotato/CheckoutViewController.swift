//
//  CheckoutViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var myVariable = 5
        var myIntVariable : Int = 5
        
        myVariable = 10000
        
        let myConst = 100
        
        myTestFunc(myVar: "FUCK YOU BITCH", myIntVar: myVariable)
        
        for i in 0 ..< 10
        {
        
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func myTestFunc(myVar : String, myIntVar : Int)
    {
        print("The string myVar was \(myVar), and myIntVar was \(myIntVar)")
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
