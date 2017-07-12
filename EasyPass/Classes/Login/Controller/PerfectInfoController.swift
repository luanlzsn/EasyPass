//
//  PerfectInfoController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class PerfectInfoController: AntController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    @IBAction func confirmClick(_ sender: UIButton) {
        kWindow?.endEditing(true)
        if !Common.isValidateEmail(email: emailField.text!) {
            AntManage.showDelayToast(message: "请输入正确的邮箱号！")
            return
        }
        if (phoneField.text?.isEmpty)! {
            AntManage.showDelayToast(message: "请输入手机号码！")
            return
        }
        weak var weakSelf = self
        AntManage.postRequest(path: "appAuth/updateAppUser", params: ["token":AntManage.userModel!.token!, "email":emailField.text!, "phone":phoneField.text!], successResult: { (response) in
            AntManage.userModel?.email = weakSelf?.emailField.text
            AntManage.userModel?.phone = weakSelf?.phoneField.text
            weakSelf?.dismiss(animated: true, completion: nil)
        }, failureResult: {})
    }
    
    @IBAction func skipClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
