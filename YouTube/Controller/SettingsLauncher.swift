//
//  SettingsLauncher.swift
//  YouTube
//
//  Created by Dante Solorio on 6/20/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class Setting: NSObject{
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Settings = "Settings"
    case Cancel = "Cancel"
    case TermsPrivacity = "Terms & privacy policy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
    
}
class SettingsLauncher: NSObject, UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        let settingsSetting = Setting(name: .Settings, imageName: "icon_settings")
        let cancelSetting = Setting(name: .Cancel, imageName: "icon_cancel")
        return [settingsSetting, Setting(name: .TermsPrivacity, imageName: "icon_privacy"), Setting(name: .SendFeedback, imageName: "icon_feedback"), Setting(name: .Help, imageName: "icon_help"), Setting(name: .SwitchAccount, imageName: "icon_switch_account"), cancelSetting]
    }()
    
    var homeController: HomeViewController?
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    func showSettings(){
        // Show menu
        
        if let window = UIApplication.sharedApplication().keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight // num of cell * height of each cell.
            let y = window.frame.height - height
            collectionView.frame = CGRectMake(0, window.frame.height, window.frame.width, height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { 
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRectMake(0, y, self.collectionView.frame.width, self.collectionView.frame.height)
                }, completion: nil)
            
        }
    }
    
    func handleDismiss(setting: Setting){
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.sharedApplication().keyWindow{
                self.collectionView.frame  = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            if setting.name != .Cancel{
                self.homeController?.showControllerForSettings(setting)
            }
        }

    }
    
    
    // MARK: - Collection view methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let setting = settings[indexPath.item]
        handleDismiss(setting)
    }
    
}
