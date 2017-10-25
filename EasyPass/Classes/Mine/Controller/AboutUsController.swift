//
//  AboutUsController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class AboutUsController: AntController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var weChat: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    var aboutUsModel: AboutUsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share_select")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(shareClick))
        
        weak var weakSelf = self
        AntManage.getRequest(path: "setting/getAppAboutUs", params: nil, successResult: { (response) in
            weakSelf?.aboutUsModel = Mapper<AboutUsModel>().map(JSON: response)
            weakSelf?.refreshView()
        }, failureResult: {
            weakSelf?.navigationController?.popViewController(animated: true)
        })
    }
    
    func shareClick() {
        AntManage.shareInfo(view: view)
    }
    
    func refreshView() {
        iconImage.sd_setImage(with: URL(string: aboutUsModel?.logoImg ?? ""), placeholderImage: UIImage(named: "default_image"))
        descr.text = aboutUsModel?.descriptionField
        phone.text = aboutUsModel?.telephone
        weChat.text = aboutUsModel?.wechatPublicNumber
        email.text = aboutUsModel?.email
        qrImage.sd_setImage(with: URL(string: aboutUsModel?.qrCodeImg ?? ""), placeholderImage: UIImage(named: "default_image"))
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
