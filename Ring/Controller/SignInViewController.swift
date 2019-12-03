//
//  SignInViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 19..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

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
        view.backgroundColor = UIColor(displayP3Red: 130/255, green: 49/255, blue: 59/255, alpha: 1)
        setupProfileImageView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[induk]+\\.[ac]+\\.[kr]"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func setupProfileImageView() {
//        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profileImageView.bottomAnchor.constraint(equalTo: Name.topAnchor, constant: -12).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(Name.snp.top).offset(-12)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
    }
   
    @IBAction func SignIn(_ sender: UIButton) {
        if !isValidEmailAddress(emailAddressString: Email.text!){
            let alert = UIAlertController(title: "회원가입 실패", message: "이메일 형식을 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
<<<<<<< HEAD
        } else if !PassWord.text!.validatePassword(){
            let alert = UIAlertController(title: "회원가입 실패", message: "대문자/소문자/숫자 8자 이상입니다. ", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))

                       self.present(alert, animated: true, completion: nil)
        } else if PassWord.text! != RePw.text! {
            let alert = UIAlertController(title: "회원가입 실패", message: "비밀번호가 같은지 확인하세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: Email.text!, password: PassWord.text!) { (authResult, error) in
                if authResult != nil {
                    //upload profile image
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                    //profile image로 사용할 때 두 가지 크기의 이미지로 저장할 수 있도록 한다.
                    if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                                       storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                            print(error as Any)
                            return
                    } else {
                        storageRef.downloadURL(completion: { (url, error) in
                        let profileImage = url?.absoluteString
                        if let email = self.Email.text {
                        if let name = self.Name.text {
                        let values = ["email" : email, "name" : name, "profileImageUrl" : profileImage] as [String : AnyObject]
                        let ref = Database.database().reference(fromURL: "https://ring-677a1.firebaseio.com/")
                        let reference = ref.child("users").child((authResult?.user.uid)!)
                        reference.updateChildValues(values)
                                }
                            }
                        })
                    }
                    })
                    }
                    //Move to Login View
                let move = self.storyboard?.instantiateViewController(withIdentifier: "LoginController")
                move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.dismiss(animated: true, completion: nil)
                } else if error != nil {
                //회원가입할때 이메일 중복있으면 alert창이 뜬다.
                print(error as Any)
                let alert = UIAlertController(title: "회원가입 실패", message: "잘못된 부분을 처리하고 다시 시도하세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
=======
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
                        let imageName = NSUUID().uuidString
                        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                        //profile image로 사용할 때 두 가지 크기의 이미지로 저장할 수 있도록 한다.
                        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    print(error as Any)
                                    
                                    return
                                }
                                else{
                                    storageRef.downloadURL(completion: { (url, error) in
                                        let profileImage = url?.absoluteString
                                        
                                        if let email = self.Email.text {
                                            if let name = self.Name.text {
                                                let values = ["email" : email, "name" : name, "profileImageUrl" : profileImage] as [String : AnyObject]
                                                let ref = Database.database().reference(fromURL: "https://ring-677a1.firebaseio.com/")
                                                let reference = ref.child("users").child((authResult?.user.uid)!)
                                                reference.updateChildValues(values)
                                            }
                                        }
                                    })
                                }
                            })
                        }
                        
                        //Move to Login View
                        let move = self.storyboard?.instantiateViewController(withIdentifier: "LoginController")
                        move?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                        
                        self.present(move!, animated: true, completion: nil)
                    } else if error != nil {
                        //회원가입할때 이메일 중복있으면 alert창이 뜬다.
                        print(error as Any)
                        let alert = UIAlertController(title: "회원가입 실패", message: "잘못된 부분을 처리하고 다시 시도하세요", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)      
>>>>>>> c7e711436b8073fc4beb50201dbf4f100a9ade82
                    }
                }
            }
        }
<<<<<<< HEAD
}

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
       // Password validation
       public func validatePassword() -> Bool {
           let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
           
           let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
           return predicate.evaluate(with: self)
       }
=======
    }
>>>>>>> c7e711436b8073fc4beb50201dbf4f100a9ade82
}
