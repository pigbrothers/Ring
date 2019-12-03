//
//  ChatMessageCell.swift
//  Ring
//
//  Created by 이주영 on 02/07/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit
import SnapKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
    static let grayColor = UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        //Tip : don't perform a lot of logic inside of a view class
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForImageView(startingImageVIew: imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.snp.makeConstraints { (make) in
            make.left.equalTo(bubbleView.snp.left)
            make.top.equalTo(bubbleView.snp.top)
            make.width.equalTo(bubbleView.snp.width)
            make.height.equalTo(bubbleView.snp.height)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(8)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(bubbleView.snp.left).offset(8)
            make.top.equalTo(self.snp.top)
            make.right.equalTo(bubbleView.snp.right)
            make.height.equalTo(self.snp.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
