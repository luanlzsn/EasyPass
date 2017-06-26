//
//  HomeHeaderCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/26.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var headImage: UIButton!//头像
    @IBOutlet weak var nickName: UILabel!//昵称
    @IBOutlet weak var bannerView: CycleScrollView!//banner
    @IBOutlet weak var famousAphorism: UILabel!//名言警句
    
    @IBAction func menuClick(_ sender: HomeMenuButton) {
        
    }
}
