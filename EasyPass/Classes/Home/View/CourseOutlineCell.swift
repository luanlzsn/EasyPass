//
//  CourseOutlineCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol CourseOutline_Delegate {
    func checkCourseOutline(section: Int)
}

class CourseOutlineCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var infoTop: NSLayoutConstraint!
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var classHour: UILabel!
    weak var delegate : CourseOutline_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func watchClick(_ sender: UIButton) {
        delegate?.checkCourseOutline(section: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
