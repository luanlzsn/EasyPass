//
//  SystemSetupController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import SDWebImage

class SystemSetupController: AntController,UITableViewDelegate,UITableViewDataSource,SystemSetup_Delegate {

    @IBOutlet weak var tableView: UITableView!
    let titleArray = ["消息提醒","仅在Wi-Fi下观看","清除缓存"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "MessageSwitch") == nil {
            let type = UIApplication.shared.currentUserNotificationSettings?.types
            if type?.rawValue == 0 {
                UserDefaults.standard.set(false, forKey: "MessageSwitch")
            } else {
                UserDefaults.standard.set(true, forKey: "MessageSwitch")
            }
            UserDefaults.standard.synchronize()
            tableView.reloadData()
        }
    }
    
    // MARK: - SystemSetup_Delegate
    func checkSwitch(_ isOn: Bool, _ tag: Int) {
        if tag == 0 {
            UserDefaults.standard.set(isOn, forKey: "MessageSwitch")
            if isOn {
                UIApplication.shared.registerForRemoteNotifications()
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.initializationJPush(launchOptions: nil)
            } else {
                UIApplication.shared.unregisterForRemoteNotifications()
            }
        } else {
            UserDefaults.standard.set(isOn, forKey: "WifiSwitch")
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == titleArray.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = titleArray[indexPath.row]
            cell.detailTextLabel?.text = String.init(format: "%.2fM", Double(SDImageCache.shared().getSize()) / 1000.0 / 1000.0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SystemSetupCell", for: indexPath) as! SystemSetupCell
            cell.delegate = self
            cell.tag = indexPath.row
            cell.titleLabel.text = titleArray[indexPath.row]
            if indexPath.row == 0 {
                cell.switchBtn.isOn = UserDefaults.standard.bool(forKey: "MessageSwitch")
            } else {
                cell.switchBtn.isOn = UserDefaults.standard.bool(forKey: "WifiSwitch")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == titleArray.count - 1 {
            SDImageCache.shared().clearDisk(onCompletion: nil)
            tableView.reloadData()
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
