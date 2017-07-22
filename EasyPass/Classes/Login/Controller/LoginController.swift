//
//  LoginController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginController: AntController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    @IBAction func weChatLoginClick(_ sender: UIButton) {
        weak var weakSelf = self
        ShareSDK.getUserInfo(SSDKPlatformType.typeWechat) { (state, user, error) in
            if state == SSDKResponseState.success {
                AntManage.postRequest(path: "appAuth/login", params: ["loginType":1, "headImg":user!.icon, "nicName":user!.nickname, "thirdId":user!.uid], successResult: { (response) in
                    AntManage.isLogin = true
                    AntManage.userModel = Mapper<UserModel>().map(JSON: response)
                    UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: AntManage.userModel!), forKey: kUserInfo)
                    UserDefaults.standard.synchronize()
                    if AntManage.userModel?.email == nil, AntManage.userModel?.phone == nil {
                        weakSelf?.performSegue(withIdentifier: "PerfectInfo", sender: nil)
                    } else {
                        weakSelf?.dismiss(animated: true, completion: nil)
                    }
                }, failureResult: {})
            }
        }
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
