//
//  Video.swift
//  YouTube
//
//  Created by Dante Solorio on 6/14/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit


class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
    
}


class Channel: NSObject {
    
    var name: String?
    var profileImageName: String?
    
    
}