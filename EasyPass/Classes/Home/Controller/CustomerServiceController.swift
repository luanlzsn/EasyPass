//
//  CustomerServiceController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class CustomerServiceController: AntController,UIGestureRecognizerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    var aboutUsModel: AboutUsModel?
    var customerServiceBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self
        AntManage.getRequest(path: "setting/getAppAboutUs", params: nil, successResult: { (response) in
            weakSelf?.aboutUsModel = Mapper<AboutUsModel>().map(JSON: response)
            weakSelf?.refreshView()
        }, failureResult: {
            weakSelf?.navigationController?.popViewController(animated: true)
        })
    }

    @IBAction func dismissClick(_ sender: UITapGestureRecognizer) {
        customerServiceBtn?.isSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    func refreshView() {
        phone.text = aboutUsModel?.telephone
        email.text = aboutUsModel?.email
        qrImage.sd_setImage(with: URL(string: aboutUsModel?.qrCodeImg ?? ""), placeholderImage: UIImage(named: "default_image"))
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
