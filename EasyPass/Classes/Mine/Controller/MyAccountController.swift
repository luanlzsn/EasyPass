//
//  MyAccountController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MyAccountController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var titleArray = ["个人头像","用户名","性别","专业","电话","邮箱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutClick(_ sender: UIButton) {
        weak var weakSelf = self
        AntManage.postRequest(path: "appAuth/logout", params: ["token":AntManage.userModel!.token!], successResult: { (_) in
            AntManage.showDelayToast(message: "退出成功！")
            AntManage.isLogin = false
            AntManage.userModel = nil
            NotificationCenter.default.post(name: NSNotification.Name(kLoginStatusUpdate), object: nil)
            ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
            UserDefaults.standard.removeObject(forKey: kUserInfo)
            UserDefaults.standard.synchronize()
            weakSelf?.navigationController?.popToRootViewController(animated: false)
            weakSelf?.tabBarController?.selectedIndex = 0
        }, failureResult: {})
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MyAccountHeadCell = tableView.dequeueReusableCell(withIdentifier: "MyAccountHeadCell", for: indexPath) as! MyAccountHeadCell
            return cell
        } else {
            let cell: MyAccountTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTextFieldCell", for: indexPath) as! MyAccountTextFieldCell
            cell.titleLabel.text = titleArray[indexPath.row]
            return cell
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
