//
//  ViewController.swift
//  YouTube
//
//  Created by Dante Solorio on 6/7/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    /*
    var videos: [Video] = {
        var exampleChannel = Channel()
        exampleChannel.name = "Example Channel Name"
        exampleChannel.profileImageName = "profile"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "New video - Blank Space"
        blankSpaceVideo.thumbnailImageName = "video_placeholder"
        blankSpaceVideo.channel = exampleChannel
        blankSpaceVideo.numberOfViews = 112123123
        
        
        var otherVideo = Video()
        otherVideo.title = "New video - other video with two lines title"
        otherVideo.thumbnailImageName = "video_placeholder"
        otherVideo.channel = exampleChannel
        otherVideo.numberOfViews = 213123123
        
        return [blankSpaceVideo, otherVideo]
    }()
    */
    
    var videos: [Video]?
    
    func fetchVideos(){
        let url = NSURL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        NSURLSession.sharedSession().dataTaskWithURL(url!){ (data, response, error ) in
            if error != nil{
                print(error)
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                self.videos = [Video]()
                
                for dictionary in json as! [[String: AnyObject]]{
                    let video = Video()
                    
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as! [String:AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    self.videos?.append(video)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.collectionView?.reloadData()
                })
                
                
            }catch let jsonError{
                print(jsonError)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.translucent = false
        
        let titleLabel = UILabel(frame: CGRectMake(0,0,view.frame.width - 32, view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .Plain, target: self, action: #selector(handleSearch))
        
        let morebutton = UIBarButtonItem(image: UIImage(named: "more_icon")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [morebutton ,searchBarButtonItem]
    }
    
    func handleSearch(){
        
    }
    
    lazy var settingsLauncher: SettingsLauncher =  {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore(){
        // Show menu        
        settingsLauncher.showSettings()
    }
    
    func showControllerForSettings(setting: Setting){
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.whiteColor()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)
    }
    
    
    // MARK: - Collection View functions
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSizeMake(view.frame.width, height + 16 + 68)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }


}