//
//  ShopCartCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol ShopCart_Delegate {
    func reduceNumber(row: Int)
    func addNumber(row: Int)
    func deleteShopCart(row: Int)
    func checkOut(row: Int)
}

class ShopCartCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var money: UILabel!
    weak var delegate : ShopCart_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func reduceNumberClick() {
        delegate?.reduceNumber(row: tag)
    }
    
    @IBAction func addNumberClick() {
        delegate?.addNumber(row: tag)
    }
    
    @IBAction func cancelClick() {
        delegate?.deleteShopCart(row: tag)
    }
    
    @IBAction func checkOutClick(_ sender: UIButton) {
        delegate?.checkOut(row: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
