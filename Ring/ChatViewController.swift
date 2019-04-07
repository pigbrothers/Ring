//
//  ChatViewController.swift
//  Ring
//
//  Created by 권혁준 on 24/02/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    @IBAction func chatPlus(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell")! as UITableViewCell
        
        return cell
    }

}
