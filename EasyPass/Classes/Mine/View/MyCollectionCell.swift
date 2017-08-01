//
//  MyCollectionCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol MyCollection_Delegate {
    func cancelCollection(row: Int)
}

class MyCollectionCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet var starArray: [UIImageView]!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var classHour: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    weak var delegate : MyCollection_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func cancelCollectionClick(_ sender: UIButton) {
        delegate?.cancelCollection(row: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
