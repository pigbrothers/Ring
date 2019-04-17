//
//  FriendTableViewCell.swift
//  Ring
//
//  Created by 권혁준 on 17/04/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import Foundation
import UIKit

class FriendTableViewCell : UITableViewCell {
    
    @IBOutlet var friendImageView : UIImage!
    @IBOutlet var  friendName : UILabel!
    @IBOutlet var friendEmail : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
