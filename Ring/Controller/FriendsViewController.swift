//
//  FriendsViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 22..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UITableViewController, UIGestureRecognizerDelegate{

    let cellId = "cellId2"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        */
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(NewFriends))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    @objc func NewFriends() {
        let popup: AlertFriendsView = UINib(nibName: AlertFriendsView.identifier, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AlertFriendsView
        popup.backgroundColor = UIColor.gray.withAlphaComponent(1)
        popup.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        popup.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
       // popup.btn_close.addTarget(self, action: #selector(btnClick_favoriteAddDialog_add), for: .touchUpInside)
        self.view.addSubview(popup);
        
    }
    
    @objc func btnClick_favoriteAddDialog_add () -> Void
    {
        NSLog("===== ViewController_item btnClick_favoriteAddDialog_add =====");
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                if user.email != Auth.auth().currentUser?.email{
                    self.users.append(user)
                }
                
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    
                    user.email = dictionary["email"] as? String
                    user.name = dictionary["name"] as? String
                    user.profileImageUrl = dictionary["profileImageUrl"] as? String
                    
                    self.setupNavBarWithUser(user: user)
                }
            }, withCancel: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func setupNavBarWithUser(user: User) {
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
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    @objc func showChatController() {
        print(123)
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
        // Dispose of any resources that can be recreated.
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
