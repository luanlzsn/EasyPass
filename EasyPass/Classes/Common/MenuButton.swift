//
//  MenuButton.swift
//  EasyPass
//
//  Created by luan on 2017/8/24.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = (width - (titleLabel?.frame.size.width)! - (imageView?.frame.size.width)!) / 2.0
        imageView?.frame.origin.x = titleLabel!.frame.size.width + titleLabel!.frame.origin.x + 2.5
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
