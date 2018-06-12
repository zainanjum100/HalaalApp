//
//  Extention.swift
//  HalaalApp
//
//  Created by ZainAnjum on 12/06/2018.
//  Copyright © 2018 ZainAnjum. All rights reserved.
//

import UIKit
extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheFromUrlString(urlString: String){
        self.image = nil
        //check for cache image first
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            self.translatesAutoresizingMaskIntoConstraints = false
            return
        }
        
        //otherwise fire off a new download
        guard let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return
        }
        
        
        let request = URLRequest(url: url as URL)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                    self.translatesAutoresizingMaskIntoConstraints = false
                }
                
            }
        }).resume()
    }
}
