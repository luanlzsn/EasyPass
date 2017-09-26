//
//  MyAccountController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class MyAccountController: AntController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MyAccountTextField_Delegate {

    @IBOutlet weak var tableView: UITableView!
    var titleArray = ["个人头像","用户名","性别","专业","电话","邮箱"]
    var contentArray = ["","","","","",""]
    let placeholderArray = ["","","请选择性别","请选择专业","请输入手机号","请输入邮箱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveAccountInfo))
        if AntManage.userModel?.nickName != nil {
            contentArray.replaceSubrange(Range(1..<2), with: [(AntManage.userModel?.nickName?.removingPercentEncoding)!])
        }
        if AntManage.userModel?.sexStr != nil {
            contentArray.replaceSubrange(Range(2..<3), with: [(AntManage.userModel?.sexStr)!])
        }
        if AntManage.userModel?.majorName != nil {
            contentArray.replaceSubrange(Range(3..<4), with: [(AntManage.userModel?.majorName)!])
        }
        if AntManage.userModel?.phone != nil {
            contentArray.replaceSubrange(Range(4..<5), with: [(AntManage.userModel?.phone)!])
        }
        if AntManage.userModel?.email != nil {
            contentArray.replaceSubrange(Range(5..<6), with: [(AntManage.userModel?.email)!])
        }
    }

    // MARK: - 保存个人信息
    func saveAccountInfo() {
        kWindow?.endEditing(true)
        weak var weakSelf = self
        var params = ["token":AntManage.userModel!.token!, "headImg":AntManage.userModel!.headImg!, "userName":AntManage.userModel?.userName ?? "", "nickName":AntManage.userModel!.nickName!, "phone":contentArray[4], "email":contentArray[5]] as [String : Any]
        if !contentArray[2].isEmpty {
            params["sex"] = (contentArray[2] == "男") ? 1 : 2
        }
        if !contentArray[3].isEmpty {
            for model in AntManage.classifyList {
                if model.name == contentArray[3] {
                    params["major"] = model.id!
                    break
                }
            }
        }
        AntManage.postRequest(path: "appAuth/updateAppUser", params: params, successResult: { (response) in
            AntManage.userModel?.sexStr = weakSelf?.contentArray[2]
            AntManage.userModel?.majorName = weakSelf?.contentArray[3]
            AntManage.userModel?.phone = weakSelf?.contentArray[4]
            AntManage.userModel?.email = weakSelf?.contentArray[5]
            NotificationCenter.default.post(name: NSNotification.Name(kLoginStatusUpdate), object: nil)
            UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: AntManage.userModel!), forKey: kUserInfo)
            UserDefaults.standard.synchronize()
            AntManage.showDelayToast(message: "保存成功")
            weakSelf?.navigationController?.popViewController(animated: true)
        }, failureResult: {})
    }
    
    func uploadImage(image: UIImage) {
        weak var weakSelf = self
        AntManage.uploadWithPath(path: "upload/uploadImg", params: ["token":AntManage.userModel!.token!, "dir":"avators"], file: UIImageJPEGRepresentation(image, 0.1)!, successResult: { (response) in
            AntManage.userModel?.headImg = response["url"] as? String
            NotificationCenter.default.post(name: NSNotification.Name(kLoginStatusUpdate), object: nil)
            UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: AntManage.userModel!), forKey: kUserInfo)
            UserDefaults.standard.synchronize()
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    // MARK: - 选择图片
    func selectPhoto() {
        let sheet = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (_) in
            weakSelf?.takingPictures(sourceType: .camera)
        }))
        sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
            weakSelf?.takingPictures(sourceType: .photoLibrary)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - 选择性别
    func selectSex() {
        let actionSheet = UIAlertController(title: "选择性别", message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        actionSheet.addAction(UIAlertAction(title: "男", style: .default, handler: { (_) in
            weakSelf?.contentArray.replaceSubrange(Range(2..<3), with: ["男"])
            weakSelf?.tableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "女", style: .default, handler: { (_) in
            weakSelf?.contentArray.replaceSubrange(Range(2..<3), with: ["女"])
            weakSelf?.tableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - 选择专业
    func selectMajor() {
        let actionSheet = UIAlertController(title: "选择专业", message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        for model in AntManage.classifyList {
            actionSheet.addAction(UIAlertAction(title: model.name, style: .default, handler: { (_) in
                weakSelf?.contentArray.replaceSubrange(Range(3..<4), with: [model.name!])
                weakSelf?.tableView.reloadData()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - MyAccountTextField_Delegate
    func textFieldEndEditing(string: String, row: Int) {
        contentArray.replaceSubrange(Range(row..<(row + 1)), with: [string])
        tableView.reloadData()
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
            if AntManage.userModel?.headImg != nil {
                cell.headImage.sd_setImage(with: URL(string: AntManage.userModel!.headImg!), placeholderImage: UIImage(named: "default_image"))
            } else {
                cell.headImage.image = UIImage(named: "head_defaults")
            }
            return cell
        } else if indexPath.row < 4 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
                cell?.selectionStyle = .none
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
            cell?.textLabel?.text = titleArray[indexPath.row]
            if contentArray[indexPath.row].isEmpty {
                cell?.detailTextLabel?.text = placeholderArray[indexPath.row]
                cell?.detailTextLabel?.textColor = UIColor(rgb: 0xcccccc)
            } else {
                cell?.detailTextLabel?.text = contentArray[indexPath.row]
                cell?.detailTextLabel?.textColor = UIColor.black
            }
            return cell!
        } else {
            let cell: MyAccountTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTextFieldCell", for: indexPath) as! MyAccountTextFieldCell
            cell.delegate = self
            cell.tag = indexPath.row
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.textField.text = contentArray[indexPath.row]
            cell.textField.placeholder = placeholderArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectPhoto()
        } else if indexPath.row == 2 {
            selectSex()
        } else if indexPath.row == 3 {
            selectMajor()
        }
    }
    
    func takingPictures(sourceType: UIImagePickerControllerSourceType) {
        if sourceType == .camera {
            if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
                let alert = UIAlertController(title: "提示", message: "无法访问摄像头！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return;
            }
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        navigationController?.present(picker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerControllerEditedImage]
            weakSelf?.uploadImage(image: image as! UIImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
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
