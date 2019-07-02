//
//  NewChatController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 22..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class AlertFriendsView: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
        tableView.register(UserCell2.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                 if user.email != Auth.auth().currentUser?.email {
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                self.tableView.reloadData()
            }
            }
        }, withCancel: nil)
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell2
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        cell.add_button.tag = indexPath.row
        cell.add_button.addTarget(self, action: #selector(addFriends), for: .touchUpInside)
       return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    @objc func addFriends(_ sender: UIButton) {

        let userAll = users[sender.tag]
        let values = ["email" : userAll.email, "name" : userAll.name, "profileImageUrl" : userAll.profileImageUrl] as [String : AnyObject]
        let id:String.Index = (userAll.email?.firstIndex(of: "@"))!
        let userid:String = String(userAll.email![...id])
        print(userid)
        let Db = Database.database().reference()
        Db.child("users").child((Auth.auth().currentUser?.uid)!).child("friends").child(userid).setValue(values)
    }
}

class UserCell2: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect.init(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect.init(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let  add_button: UIButton = {
       let add_button = UIButton()
        add_button.setTitle("Plus", for: .normal)
        add_button.setTitleColor(.white, for: .normal)
        add_button.backgroundColor = .darkGray
        add_button.translatesAutoresizingMaskIntoConstraints = false
        return add_button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(add_button)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        add_button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        add_button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        add_button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        add_button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
