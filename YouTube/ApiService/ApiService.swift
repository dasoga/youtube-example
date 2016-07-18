//
//  ApiService.swift
//  YouTube
//
//  Created by Dante Solorio on 7/1/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func fetchVideos(completion: ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString:String, completion: ([Video]) -> ()){
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!){ (data, response, error ) in
            if error != nil{
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, jsonDictionaries = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers) as?  [[String: AnyObject]]{
                  
//                    var videos = [Video]()
//                    
//                    for dictionary in jsonDictionaries{
//                        let video = Video(dictionary: dictionary)
//                        videos.append(video)
//                    }
                    let videos = jsonDictionaries.map({return Video(dictionary: $0)})
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(videos)
                    })
                    
                }
                
                
            }catch let jsonError{
                print(jsonError)
            }
            }.resume()
    }
}




