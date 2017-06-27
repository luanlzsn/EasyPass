//
//  MineLearnRecordCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MineLearnRecordCell: UITableViewCell {

    @IBOutlet weak var studyDay: UILabel!//学习天数
    @IBOutlet weak var completeCourse: UILabel!//完成课程
    @IBOutlet weak var points: UILabel!//获得积分
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
