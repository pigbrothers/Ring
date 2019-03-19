//
//  SignInViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 19..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet var Email: UITextField!
    @IBOutlet var PassWord: UITextField!
    @IBOutlet var RePw: UITextField!
    @IBOutlet var Name: UITextField!
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        setupProfileImageView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: Name.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
   
    @IBAction func SignIn(_ sender: UIButton) {
        if PassWord.text! == "" || RePw.text! == "" || Email.text! == "" || Name.text! == "" {
            let alert = UIAlertController(title: "회원가입 실패", message: "공백이 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if PassWord.text! != RePw.text! { //비밀번호를 확인할때 위와 똑같은 비밀번호를 쓰지 않으면 발생하는 alert
                let alert = UIAlertController(title: "회원가입 실패", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                Auth.auth().createUser(withEmail: Email.text!, password: PassWord.text!) { (authResult, error) in
                    if authResult != nil {
                        
                        //upload profile image
                        let storageRef = Storage.storage().reference().child("myImage.png")
                        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    print(error)
                                    return
                                }
                                print(metadata)
                            })
                        }
                        
                        //put data on realtime database
                        let ref =  Database.database().reference(fromURL: "https://ring-677a1.firebaseio.com/")
                        let Reference = ref.child("users").child((authResult?.user.uid)!)
                        let values = ["email" : self.Email.text!, "name" : self.Name.text!]
                        Reference.updateChildValues(values)
                        
                        let move = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                        move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                        
                        self.present(move!, animated: true, completion: nil)
                    }
                    else if error != nil {
                        //회원가입할때 이메일 중복있으면 alert창이 뜬다.
                         print(error)
                        let alert = UIAlertController(title: "회원가입 실패", message: "잘못된 부분을 처리하고 다시 시도하세요", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)      
                    }
                }
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
