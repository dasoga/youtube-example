//
//  SettingCell.swift
//  YouTube
//
//  Created by Dante Solorio on 6/23/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            titleLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet{
            titleLabel.text = setting?.name.rawValue
            
            if let imageName = setting?.imageName{
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
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
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Setting"
        label.textAlignment = .left
        return label
    }()
    
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_settings")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
}
