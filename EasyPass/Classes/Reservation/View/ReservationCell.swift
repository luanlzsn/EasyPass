//
//  ReservationCell.swift
//  EasyPass
//
//  Created by luan on 2017/6/28.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol Reservation_Delegate {
    func reservationCourse(row: Int)
}

class ReservationCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet var starArray: [UIImageView]!
    weak var delegate : Reservation_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func reservationClick() {
        delegate?.reservationCourse(row: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
