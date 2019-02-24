//
//  FriendViewController.swift
//  Ring
//
//  Created by 권혁준 on 24/02/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    
    @IBOutlet weak var tableView: UITableView!
    
    let items: [String] = [(Auth.auth().currentUser?.displayName)!, "swift", "ios"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCell")! as UITableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "FCell")! as UITableViewCell
        cell2.textLabel?.text = items[indexPath.row]
        cell.textLabel?.text = items[indexPath.row]
        
        if(items[indexPath.row] == (Auth.auth().currentUser?.displayName)!)
        {
            
            return cell
        }
        else{
            
            return cell2
        }
    
    }
    
    
}
