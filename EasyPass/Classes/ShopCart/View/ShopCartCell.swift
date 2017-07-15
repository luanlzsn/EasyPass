//
//  ShopCartCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class ShopCartCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var money: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func reduceNumberClick() {
        
    }
    
    @IBAction func addNumberClick() {
        
    }
    
    @IBAction func cancelClick() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
