//
//  MyAccountTextFieldCell.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol MyAccountTextField_Delegate {
    func textFieldEndEditing(string: String, row: Int)
}

class MyAccountTextFieldCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: MyAccountTextField_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEndEditing(string: textField.text!, row: tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
