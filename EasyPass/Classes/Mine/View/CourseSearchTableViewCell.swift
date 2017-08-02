//
//  CourseSearchTableViewCell.swift
//  EasyPass
//
//  Created by luan on 2017/8/2.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol CourseSearch_Delegate {
    func deleteSearch(row: Int)
}

class CourseSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchContent: UILabel!
    weak var delegate : CourseSearch_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteSearchClick(_ sender: UIButton) {
        delegate?.deleteSearch(row: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
