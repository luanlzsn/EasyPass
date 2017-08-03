//
//  SystemSetupCell.swift
//  EasyPass
//
//  Created by luan on 2017/8/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol SystemSetup_Delegate {
    func checkSwitch(_ isOn: Bool, _ tag: Int)
}

class SystemSetupCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    weak var delegate: SystemSetup_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchClick(_ sender: UISwitch) {
        delegate?.checkSwitch(sender.isOn, tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
