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
        }
    }
}
