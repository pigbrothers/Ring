//
//  AlertFreindsView.swift
//  Ring
//
//  Created by 권혁준 on 03/05/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit

class AlertFriendsView : UIView {
    
    class var identifier: String{
        let xibName = "AlertFriendsView"
        return  xibName
        
    }
    
    class func instanceFromNib() -> UIView{
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
