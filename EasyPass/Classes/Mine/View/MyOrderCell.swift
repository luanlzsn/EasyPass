//
//  MyOrderCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol MyOrder_Delegate {
    func cancelOrder(section: Int)
}

class MyOrderCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet var starArray: [UIImageView]!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var classHour: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var alreadyPaid: UILabel!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    weak var delegate : MyOrder_Delegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func cancelOrderClick(_ sender: UIButton) {
        delegate?.cancelOrder(section: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
