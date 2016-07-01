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
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationController?.navigationBar.translucent = false
        
        let titleLabel = UILabel(frame: CGRectMake(0,0,view.frame.width - 32, view.frame.height))
        titleLabel.text = "  Home"
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
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(230, green: 32, blue: 31)
        view.addSubview(redView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: redView)
        view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
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