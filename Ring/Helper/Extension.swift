//
//  Extension.swift
//  Ring
//
//  Created by 이주영 on 11/04/2019.
//  Copyright © 2019 pigBrothers. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        print(url as Any)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }
            
            DispatchQueue.main.async {
                if let downloadedIamge = UIImage(data: data!) {
                    imageCache.setObject(downloadedIamge, forKey: urlString as AnyObject)
                    self.image = downloadedIamge
                }
                
            }
        }.resume()
    }
}
