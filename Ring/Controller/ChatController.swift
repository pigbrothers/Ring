//
//  ChatController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 22..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class ChatController: UITableViewController, UIGestureRecognizerDelegate {
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(handleNewChat))
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        //observeMessages()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            })
        }
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
        })
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReladTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReladTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timeStamp!.intValue > message2.timeStamp!.intValue
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timeStamp!.intValue > message2.timeStamp!.intValue
                    })
                }
                //thread 문제 해결을 위한 코드
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReladTable), userInfo: nil, repeats: false)
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            //print(snapshot)
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            let user = User()
            
            user.id = chatPartnerId
            user.email = dictionary["email"] as? String
            user.name = dictionary["name"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            self.showChatControllerForUser(user)
        }
    }
    
    @objc func handleNewChat() {
        let newChatController = NewChatController()
        newChatController.chatController = self
        let navController = UINavigationController(rootViewController: newChatController)
        
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let user = User()
                    
                    user.id = dictionary["id"] as? String
                    user.email = dictionary["email"] as? String
                    user.name = dictionary["name"] as? String
                    user.profileImageUrl = dictionary["profileImageUrl"] as? String
                    
                    self.setupNavBarWithUser(user: user)
                }
            }, withCancel: nil)
        }
    }
    
    func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left)
            make.centerY.equalTo(containerView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.right.equalTo(containerView.snp.right)
            make.height.equalTo(profileImageView.snp.height)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.centerY.equalTo(titleView.snp.centerY)
        }
        
        self.navigationItem.titleView = titleView
        /*
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showChatController))
         self.navigationController?.navigationBar.addGestureRecognizer(tapGesture)
         self.navigationController?.navigationBar.isUserInteractionEnabled = true
         */
    }
    
    @objc func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        }   catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
