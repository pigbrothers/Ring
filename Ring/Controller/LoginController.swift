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

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    let buttonText = NSAttributedString(string: "FaceBook Login")
    @IBOutlet weak var GIDbtn : GIDSignInButton!
    @IBOutlet weak var FBbtn: FBSDKButton!
    @IBOutlet var MainLogo: UILabel!
    
    var window: UIWindow?
    @IBOutlet var PwText: UITextField!
    @IBOutlet var EmailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainLogo.alpha = 0
        
        UIView.animate(withDuration: 2.0) {
            self.MainLogo.alpha = 1
        }
       
        //var preferredStatusBarStyle : UIStatusBarStyle = StatusBarStyle()
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        FBbtn.setAttributedTitle(buttonText, for: .normal)
        view.backgroundColor = UIColor(displayP3Red: 221/255, green: 245/255, blue: 249/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookLogin(sender: AnyObject){
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
            Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                if authResult != nil {
                    let ref =  Database.database().reference(fromURL: "https://ring-677a1.firebaseio.com/")
                    let Reference = ref.child("users").child((authResult?.uid)!)
                    let values = ["email" : Auth.auth().currentUser?.email, "name" : Auth.auth().currentUser?.displayName, "profileImageUrl" : "https://firebasestorage.googleapis.com/v0/b/ring-677a1.appspot.com/o/profile_images%2F143E6E0A-1589-4BBF-8E2E-74AEBB3F19B4.png?alt=media&token=6a5cbf02-46d6-4d06-90db-8f7e6b33ead9"]
                    
                    Reference.updateChildValues(values)
                }
                let move = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
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
                let move = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
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
