//
//  SubscriptionCell.swift
//  YouTube
//
//  Created by Dante Solorio on 7/10/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
