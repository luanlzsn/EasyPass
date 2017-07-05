//
//  MyCourseCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MyCourseCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet var starArray: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseImage.setImageWith(URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498639227000&di=90a7936124fdde941224563e472c6623&imgtype=0&src=http%3A%2F%2Fwww.moore8.com%2Fassets%2Fimg%2Fcampaign%2FshortVideo%2Flw.jpg")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
