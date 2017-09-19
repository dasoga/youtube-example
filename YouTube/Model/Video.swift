//
//  Video.swift
//  YouTube
//
//  Created by Dante Solorio on 6/14/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit


class Video: NSObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: Date?
    var duration: NSNumber?
    
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel"{            
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String:AnyObject])
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]){
        super.init()
        setValuesForKeys(dictionary)
    }
    
}


class Channel: NSObject {
    
    var name: String?
    var profile_image_name: String?
    
    
}
