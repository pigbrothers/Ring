//
//  ViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 15..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var PwText: UITextField!
    @IBOutlet var EmailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

