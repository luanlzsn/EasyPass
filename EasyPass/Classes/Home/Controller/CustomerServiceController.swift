//
//  CustomerServiceController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CustomerServiceController: AntController,UIGestureRecognizerDelegate {

    @IBOutlet weak var contentView: UIView!
    var customerServiceBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissClick(_ sender: UITapGestureRecognizer) {
        customerServiceBtn?.isSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == contentView {
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
