//
//  LoginViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/17.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit
import LocalAuthentication
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var touchButton: UIButton!
    
    @IBAction func loginInAction(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error != nil)
        {
            createAlert(title: "Google Auth failed", message: "Google signin was not authorised by user.")
            print(error.localizedDescription)
            return
        }
        performSegue(withIdentifier: "ListSegue", sender: self)
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 15
        checkTouchIDCapabiliy()
        GIDSignIn.sharedInstance().clientID = "419294114683-hp17127ml91p1g0p69vge908o90uikdm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
