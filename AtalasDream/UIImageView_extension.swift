//
//  UIImageView_extension.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageFrom(urlString: String) {
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (imageData, urlResponse, error) in
                if error != nil {
                    self.image = UIImage(named: "anonymous")
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: imageData!) {
                        self.image = downloadedImage
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    }
                }
            }).resume()
        }
    }
}
