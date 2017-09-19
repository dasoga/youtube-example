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
    
    func fetchVideos(_ completion: @escaping ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)home.json", completion: completion)
    }
    
    func fetchTrendingFeed(_ completion: @escaping ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(_ completion: @escaping ([Video]) -> ()){
        fetchFeedForUrlString("\(baseUrl)subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(_ urlString:String, completion: @escaping ([Video]) -> ()){
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error ) in
            if error != nil{
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as?  [[String: AnyObject]]{
                  
//                    var videos = [Video]()
//                    
//                    for dictionary in jsonDictionaries{
//                        let video = Video(dictionary: dictionary)
//                        videos.append(video)
//                    }
                    let videos = jsonDictionaries.map({return Video(dictionary: $0)})
                    
                    DispatchQueue.main.async(execute: {
                        completion(videos)
                    })
                    
                }
                
                
            }catch let jsonError{
                print(jsonError)
            }
            }).resume()
    }
}




