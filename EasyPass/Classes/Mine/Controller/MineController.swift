//
//  MineController.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MineController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var userRecord : UserRecordModel?
    let imageArray = ["mine_my_course","mine_my_collection","mine_my_order","mine_message_center","mine_common_problem","mine_about_us","mine_system_setup"]
    let identifierArray = ["MyCourse","MyCollection","MyOrder","Message","CommonProblem","AboutUs","SystemSetup"]
    let titleArray = ["我的课程","我的收藏","我的订单","消息中心","常见问题","关于我们","系统设置"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        getAppUserRecord()
    }
    
    // MARK: - 获取用户学习记录
    func getAppUserRecord() {
        weak var weakSelf = self
        AntManage.postRequest(path: "appuser/getAppUserRecord", params: ["token":AntManage.userModel!.token!], successResult: { (response) in
            weakSelf?.userRecord = Mapper<UserRecordModel>().map(JSON: response)
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }

    @IBAction func logoutClick() {
        weak var weakSelf = self
        AntManage.postRequest(path: "appAuth/logout", params: ["token":AntManage.userModel!.token!], successResult: { (_) in
            AntManage.showDelayToast(message: "退出成功！")
            AntManage.isLogin = false
            AntManage.userModel = nil
            JPUSHService.deleteAlias({ (_, nil, _) in
                
            }, seq: 1)
            NotificationCenter.default.post(name: NSNotification.Name(kLoginStatusUpdate), object: nil)
            ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
            UserDefaults.standard.removeObject(forKey: kUserInfo)
            UserDefaults.standard.synchronize()
            weakSelf?.tabBarController?.selectedIndex = 0
            AntManage.touristLogin()
        }, failureResult: {})
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : imageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? 75 : 50
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: MineHeadCell = tableView.dequeueReusableCell(withIdentifier: "MineHeadCell", for: indexPath) as! MineHeadCell
                if AntManage.userModel?.headImg != nil {
                    cell.headImage.sd_setImage(with: URL(string: AntManage.userModel!.headImg!), placeholderImage: UIImage(named: "default_image"))
                } else {
                    cell.headImage.image = UIImage(named: "head_defaults")
                }
                cell.nickName.text = AntManage.userModel?.nickName?.removingPercentEncoding
                return cell
            } else {
                let cell: MineLearnRecordCell = tableView.dequeueReusableCell(withIdentifier: "MineLearnRecordCell", for: indexPath) as! MineLearnRecordCell
                cell.studyDay.text = "\(userRecord?.studyDayNum ?? 0)天"
                cell.completeCourse.text = "\(userRecord?.finishCourseHour ?? 0)个"
                cell.points.text = "\(userRecord?.score ?? 0)"
                return cell
            }
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
            cell.textLabel?.text = titleArray[indexPath.row]
            cell.detailTextLabel?.text = (indexPath.row == 2) ? "" : ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "MyAccount", sender: nil)
            }
        } else {
            performSegue(withIdentifier: identifierArray[indexPath.row], sender: nil)
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
