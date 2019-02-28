//
//  ViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 15..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController, GIDSignInUIDelegate{

     var window: UIWindow?
    @IBOutlet var PwText: UITextField!
    @IBOutlet var EmailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.signOut()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    @IBAction func facebookLogin(sender: AnyObject) {
        let LoginManager = FBSDKLoginManager()
        
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                let move = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController")
                move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.present(move!, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func SignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

        if GIDSignIn.sharedInstance()?.currentUser == nil {
            let move = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController")
            move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(move!, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func LoginBtn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: EmailText.text!, password: PwText.text!) { (user, error) in
            if user != nil {
                let move = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController")
                move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.present(move!, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "로그인 실패", message: "잘못된 회원정보를 입력하셨습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

