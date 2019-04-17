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
import SwiftyJSON

class FriendViewController: UIViewController, UISearchResultsUpdating{
    
    
    var pic = UIImage()
    var items : [String] = []
    var dataJson = JSON()
    let ref = Database.database().reference()
    let str = Storage.storage()
    @IBOutlet weak var tableView: UITableView!
    var resultSearchController = UISearchController()
    var filteredTableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.dataJson = JSON(vin)
            print(self.dataJson)
            print(self.dataJson.count)
            for (key, value) in self.dataJson {
                print(key)
                self.items.append(key)
            }
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (items as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        self.tableView.reloadData()
    }
}
extension FriendViewController : UITableViewDataSource{
  
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int ) -> Int {
            return self.dataJson.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCell", for : indexPath as IndexPath) as! FriendTableViewCell
        
        let imageUrl = dataJson[items[indexPath.row]]["image"].stringValue
        cell.friendName.text = dataJson[items[indexPath.row]]["name"].stringValue
        cell.friendEmail.text = dataJson[items[indexPath.row]]["email"].stringValue
        let storageRef = str.reference(forURL: imageUrl)
        storageRef.getData(maxSize: 1*1024*1024){ data, error in
            if let error = error{
                print(error.localizedDescription)
            }else{
            let poto = UIImage(data: data!)
            self.pic = poto!
            }
        }
      cell.friendImageView = pic
        
        return cell
    }
}
extension FriendViewController : UITableViewDelegate{
    
}
    


