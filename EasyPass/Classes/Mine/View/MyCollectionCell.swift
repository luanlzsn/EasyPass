//
//  MyCollectionCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MyCollectionCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet var starArray: [UIImageView]!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var classHour: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func buyClick(_ sender: UIButton) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
