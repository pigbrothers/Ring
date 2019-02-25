//
//  ChatRoomViewController.swift
//  Ring
//
//  Created by 권혁준 on 25/02/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    var nowMessage = [String : String]()
    var message = ["hh"]
    //내가 messageField에 텍스트를 전송버튼으로 눌렀을 때
    //텍스트가 위 변수에 저장되고 그 내용이 cell에 출력되게 하고싶다.
    //이걸 할때 [유저아이디 : 텍스트내용] 형식으로 저장해서 내 아이디와 유저아이디가 같으면 MyCell에 나타나게 해주고
    // 나머지는 OtherCell에 출력되게 하자
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")! as UITableViewCell
        cell.textLabel?.text = message[indexPath.row]
        return cell
    }
  
    @IBAction func submit(_ sender: UIButton) {
        if messageField.text! != "" {
            nowMessage[(Auth.auth().currentUser?.uid)!] = messageField.text!
            message.append(messageField.text!)
            let ref =  Database.database().reference(fromURL: "https://ring-677a1.firebaseio.com/")
            print(message)
            messageField.text = ""
        }
        
        self.tableView.reloadData()
    }
    
}
