//
//  OrderBuyTimeCell.swift
//  EasyPass
//
//  Created by luan on 2017/8/14.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol OrderBuyTime_Delegate {
    func paymentClick(_ section: Int)
    func cancelOrderClick(_ section: Int)
}

class OrderBuyTimeCell: UITableViewCell {

    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var buyTime: UILabel!
    @IBOutlet weak var prompt: UILabel!
    weak var delegate: OrderBuyTime_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func paymentClick(_ sender: UIButton) {
        delegate?.paymentClick(tag)
    }
    
    @IBAction func cancelOrderClick(_ sender: UIButton) {
        delegate?.cancelOrderClick(tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
