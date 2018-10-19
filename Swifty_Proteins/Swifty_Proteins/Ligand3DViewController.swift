//
//  Ligand3DViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit

class Ligand3DViewController: UIViewController
{
    static var ligand:String!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Ligand " + Ligand3DViewController.ligand + "structure"

        // Do any additional setup after loading the view.
    }

    func retrieveLigandPDB()
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
