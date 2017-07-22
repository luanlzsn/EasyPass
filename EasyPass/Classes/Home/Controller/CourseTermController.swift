//
//  CourseTermController.swift
//  EasyPass
//
//  Created by luan on 2017/7/15.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CourseTermController: AntController,UIGestureRecognizerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var termArray: [UIButton]!
    var term = -1
    var changeTerm: ConfirmBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in termArray {
            button.isSelected = button.tag == term
            button.backgroundColor = button.isSelected ? MainColor : UIColor.white
        }
    }

    @IBAction func termClick(_ sender: UIButton) {
        for button in termArray {
            button.isSelected = (button == sender)
            button.backgroundColor = button.isSelected ? MainColor : UIColor.white
            if button.isSelected {
                term = button.tag
            }
        }
        if changeTerm != nil {
            changeTerm!(term)
            changeTerm = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissClick(_ sender: UITapGestureRecognizer) {
        if changeTerm != nil {
            changeTerm = nil
        }
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
