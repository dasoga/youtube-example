//
//  Extensions.swift
//  YouTube
//
//  Created by Dante Solorio on 6/7/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func addConstraintsWithFormat(_ format: String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCahe = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView{
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String){
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCahe.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString{
                    self.image = imageToCache
                }
                
                imageCahe.setObject(imageToCache!, forKey: urlString as AnyObject)
                            
            })
            
            
        }).resume()
    }
}
