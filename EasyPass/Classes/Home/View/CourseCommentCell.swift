//
//  CourseCommentCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CourseCommentCell: UITableViewCell {

    @IBOutlet weak var headPortrait: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commont: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headPortrait.sd_setImage(with: URL(string: "http://www.qq745.com/uploads/allimg/140928/1-14092PRT2-50.jpg")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
