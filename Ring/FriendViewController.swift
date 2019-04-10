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

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (items as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        self.tableView.reloadData()
    }
    
    @IBAction func PlusFriend(_ sender: Any) {
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let items: [String] = [((Auth.auth().currentUser?.email)!), "swift", "ios"]
    var resultSearchController = UISearchController()
    var filteredTableData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        
        ref.child("users").observeSingleEvent(of: .value) { snapShot in
            let vin = snapShot.value as?  Dictionary<String, AnyObject>
            
            print(vin?.startIndex)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }else{
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCell")! as UITableViewCell
       // let cell2 = tableView.dequeueReusableCell(withIdentifier: "FCell")! as UITableViewCell
        //cell2.textLabel?.text = items[indexPath.row]
        cell.textLabel?.text = items[indexPath.row]
        
        if self.resultSearchController.isActive {
            cell.textLabel?.text = filteredTableData[indexPath.row]
        } else {
            cell.textLabel?.text = items[indexPath.row]
        }
        /*  주석을 풀면 cell두개를 내 상황에 따라 자유롭게 움직일수 있다.
        if(items[indexPath.row] == (Auth.auth().currentUser?.displayName)!)
        {
            return cell
        }
        else{
            return cell2
        }
         */
        return cell
    }
    
    
}
