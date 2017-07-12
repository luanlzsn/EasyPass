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
    let menuIdentifierArray = ["AboutUs","CourseSearch","MyCourse","Message"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func menuClick(_ sender: HomeMenuButton) {
        let identifier = menuIdentifierArray[sender.tag / 10 - 1]
        let controller = UIStoryboard(name: "Mine", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        viewController()?.navigationController?.pushViewController(controller, animated: true)
    }
}
