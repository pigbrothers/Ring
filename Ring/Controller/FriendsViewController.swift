//
//  FriendsViewController.swift
//  Ring
//
//  Created by comsoft on 2019. 2. 22..
//  Copyright © 2019년 pigBrothers. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class FriendsViewController: UITableViewController, UIGestureRecognizerDelegate{
    var messages = [Message]()
    let cellId = "cellId2"
    var users = [User]()
    var chatcontroler : ChatController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        */
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(NewFriends))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    @objc func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }
      
    }
    
    @objc func NewFriends() {
        let newChatController = AlertFriendsView()
        let navController = UINavigationController(rootViewController: newChatController)
        
        present(navController, animated: true, completion: nil)
        /*
        let popup: AlertFriendsView = UINib(nibName: AlertFriendsView.identifier, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AlertFriendsView
        popup.backgroundColor = UIColor.gray.withAlphaComponent(1)
        popup.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        popup.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
       // popup.btn_close.addTarget(self, action: #selector(btnClick_favoriteAddDialog_add), for: .touchUpInside)
        self.view.addSubview(popup);
 
         */
    }
    
    @objc func btnClick_favoriteAddDialog_add () -> Void {
        NSLog("===== ViewController_item btnClick_favoriteAddDialog_add =====");
    }
    
    @objc func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        let alert = UIAlertController(title: user.email, message: "이 사용자와 채팅을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okA = UIAlertAction(title: "네", style: .default) { (action) in
            self.showChatControllerForUser(user)
        }
        let defaultA = UIAlertAction(title: "아니요", style: .cancel, handler : nil)
        alert.addAction(okA)
        alert.addAction(defaultA)
        present(alert, animated: false, completion: nil)
    }
    
    
    func upInfoBar(_ user : User) {
        let infoView = UIView()
        infoView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = dictionary["id"] as? String
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
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left)
            make.centerY.equalTo(containerView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
//        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
//        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.centerY.equalTo(titleView.snp.centerY)
        }
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
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
