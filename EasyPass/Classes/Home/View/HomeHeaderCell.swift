//
//  HomeHeaderCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/26.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell,CycleScrollView_Delegate {
    
    @IBOutlet weak var headImage: UIButton!//头像
    @IBOutlet weak var nickName: UILabel!//昵称
    @IBOutlet weak var bannerView: CycleScrollView!//banner
    @IBOutlet weak var famousAphorism: UILabel!//名言警句
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerView.delegate = self
        bannerView.setBannerWithUrlArry(urlArry: ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498561664479&di=d5e9c79ebb320e04b3df3a51b2d77e39&imgtype=0&src=http%3A%2F%2Fwww.dv37.com%2Fupload%2Feditor%2F201505%2F1430892739_801872.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498561733052&di=4970e66975399d218654cf4c9ce36caa&imgtype=0&src=http%3A%2F%2Fwww.keedu.cn%2Fstatic%2F643%2Fpic%2F201506011358584957470.jpg"])
    }
    
    @IBAction func menuClick(_ sender: HomeMenuButton) {
        
    }
    
    // MARK: - CycleScrollView_Delegate
    func didSelectBanner(index: Int) {
        
    }
}
