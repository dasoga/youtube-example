//
//  SettingsLauncher.swift
//  YouTube
//
//  Created by Dante Solorio on 6/20/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    override init() {
        super.init()
        
        
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
            
            let height: CGFloat = 200
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
    
    func handleDismiss(){
        UIView.animateWithDuration(0.4) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.sharedApplication().keyWindow{
            self.collectionView.frame  = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)
            }
        }
    }
    
    
}
