//
//  SettingCell.swift
//  YouTube
//
//  Created by Dante Solorio on 6/23/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var highlighted: Bool {
        didSet{
            backgroundColor = highlighted ? UIColor.darkGrayColor() : UIColor.whiteColor()
            titleLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
            iconImageView.tintColor = highlighted ? UIColor.whiteColor() : UIColor.darkGrayColor()
        }
    }
    
    var setting: Setting? {
        didSet{
            titleLabel.text = setting?.name
            
            if let imageName = setting?.imageName{
                iconImageView.image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
                iconImageView.tintColor = UIColor.darkGrayColor()
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat("H:|-8-[v0(30)]-8-[v1]|", views: iconImageView ,titleLabel)
        addConstraintsWithFormat("V:|[v0]|", views: titleLabel)
        
        addConstraintsWithFormat("V:[v0(30)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.text = "Setting"
        return label
    }()
    
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_settings")
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
}