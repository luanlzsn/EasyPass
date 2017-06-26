//
//  HomeMenuButton.swift
//  EasyPass
//
//  Created by luan on 2017/6/26.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class HomeMenuButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleEdgeInsets = UIEdgeInsetsMake(0, -(currentImage?.size.width)!, -(currentImage?.size.height)! - 20, 0)
        imageView?.centerX = width / 2.0
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
