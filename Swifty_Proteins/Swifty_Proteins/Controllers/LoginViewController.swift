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
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var touchButton: UIButton!
    
    @IBAction func loginInAction(_ sender: UIButton)
    {
       
        if (Username.text == "" || password.text == "")
        {
            self.createAlert(title: "Missing credentials", message: "Username or password is missing")
        }
        else
        {
            performSegue(withIdentifier: "ListSegue", sender: self)
             //got nothing to do robably proceed to the next scrren
        }
    }
    
    @IBAction func touchIDAuth(_ sender: UIButton)
    {
        let context = LAContext()

        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Fingerprint login required.", reply:
            {
                (correctPrint, error) in
                if (correctPrint == true)
                {
                    DispatchQueue.main.async
                    {
                        self.performSegue(withIdentifier: "ListSegue", sender: self)
                    }
                
                    
                }
                else
                {
                     self.createAlert(title: "Touch Auth Failed", message: "Wrong fingerprint submitted")
                }
                
            }
        )
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 15
        checkTouchIDCapabiliy()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title : title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
            {
                (action) in
                alert.dismiss(animated: true, completion: nil)
            }
        ))
        present(alert,animated: true, completion: nil)
    }
    
    func checkTouchIDCapabiliy()
    {
        let context = LAContext()
        
        if (!context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil))
        {
            touchButton.isHidden = true
        }
        else
        {
            if (context.biometryType != .touchID)
            {
                touchButton.isHidden = true
            }
        }
    }
}
