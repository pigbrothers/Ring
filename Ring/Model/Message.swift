//
//  Message.swift
//  Ring
//
//  Created by 권혁준 on 18/07/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String? //보낸 사람
    var text: String? //내용
    var timeStamp: NSNumber? //시간 정보
    var toId: String? //받는 사람
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId //현재 로그인한 사용자와 보낸 사람이 일치하다면 받는 사람을 uid를 리턴 아니면 보낸 사람 리턴
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
}
