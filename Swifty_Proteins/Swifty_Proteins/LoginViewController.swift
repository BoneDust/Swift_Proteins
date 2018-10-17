//
//  LoginViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/17.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController
{

    
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var touchButton: UIButton!
    
    @IBAction func loginInAction(_ sender: UIButton)
    {
        //got nothing to do
    }
    
    @IBAction func touchIDAuth(_ sender: UIButton)
    {
        let context = LAContext()

        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Fingerprint login required.", reply:
            {
                (correctPrint, error) in
                if (correctPrint == true)
                {
                    //proceed to next screen
                    print("\ncontinuing to the next screen")
                }
                else
                {
                    
                }
            }
        )
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkTouchIDCapabiliy()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTouchIDCapabiliy()
    {
        let context = LAContext()
        
        if (!context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil))
        {
            touchButton.isHidden = true
        }
    }
}
