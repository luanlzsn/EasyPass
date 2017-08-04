//
//  LeomanSingleton.swift
//  MoFan
//
//  Created by luan on 2017/1/4.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import MJExtension

let kRequestTimeOut = 20.0
let AntManage = AntSingleton.sharedInstance

class AntSingleton: NSObject {
    
    static let sharedInstance = AntSingleton()
    var manager = AFHTTPSessionManager()
    var progress : MBProgressHUD?
    var progressCount = 0//转圈数量
    var isLogin = false//是否登录    
    var userModel: UserModel?
    var classifyList = [ClassifyModel]()//专业数组
    
    private override init () {
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json","text/json","text/javascript","text/html")
        manager.requestSerializer.timeoutInterval = kRequestTimeOut
    }
    
    //MARK: - post请求
    func postRequest(path:String, params:[String : Any]?, successResult:@escaping ([String : Any]) -> Void, failureResult:@escaping () -> Void) {
        AntLog(message: "请求接口：\(path),请求参数：\(String(describing: params))")
        showMessage(message: "")
        weak var weakSelf = self
        
        manager.post(kRequestBaseUrl + path, parameters: params, progress: nil, success: { (task, response) in
            weakSelf?.requestSuccess(response: response, successResult: successResult, failureResult: failureResult)
        }) { (task, error) in
            weakSelf?.hideMessage()
            weakSelf?.showDelayToast(message: "未知错误，请重试！")
            failureResult()
        }
    }
    
    func postSumbitOrder(body:[String : Any]?, successResult:@escaping ([String : Any]) -> Void, failureResult:@escaping () -> Void) {
        AntLog(message: "请求接口：order/sumbitOrder,请求参数：\(String(describing: body))")
        showMessage(message: "")
        
        let sarequestUrl = kRequestBaseUrl + "order/sumbitOrder?token=\(userModel!.token!)"
        let formRequest = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: sarequestUrl, parameters: nil, error: nil)
        formRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        formRequest.timeoutInterval = kRequestTimeOut
        formRequest.httpBody = (body! as NSDictionary).mj_JSONData()
        
        let manager = AFHTTPSessionManager()
        
        let responseSerializer = AFJSONResponseSerializer()
        responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json","text/json","text/javascript","text/html","text/plain")
        manager.responseSerializer = responseSerializer
        
        weak var weakSelf = self
        
        let dataTask = manager.dataTask(with: formRequest as URLRequest) { (response, data, error) in
            if error == nil {
                weakSelf?.requestSuccess(response: data, successResult: successResult, failureResult: failureResult)
            } else {
                weakSelf?.hideMessage()
                weakSelf?.showDelayToast(message: "未知错误，请重试！")
                failureResult()
            }
        }
        dataTask.resume()
    }
    
    // MARK: - get请求
    func getRequest(path:String, params:[String : Any]?, successResult:@escaping ([String : Any]) -> Void, failureResult:@escaping () -> Void) {
        AntLog(message: "请求接口：\(path),请求参数：\(String(describing: params))")
        showMessage(message: "")
        weak var weakSelf = self
        
        manager.get(kRequestBaseUrl + path, parameters: params, progress: nil, success: { (task, response) in
            weakSelf?.requestSuccess(response: response, successResult: successResult, failureResult: failureResult)
        }) { (task, error) in
            weakSelf?.hideMessage()
            weakSelf?.showDelayToast(message: "未知错误，请重试！")
            failureResult()
        }
    }
    
    // MARK: - 上传图片
    func uploadWithPath(path: String, params: [String : Any]?, file: Data, successResult:@escaping ([String : Any]) -> Void, failureResult:@escaping () -> Void) {
        AntLog(message: "请求接口：\(path),请求参数：\(String(describing: params))")
        showMessage(message: "")
        weak var weakSelf = self
        
        manager.post(kRequestBaseUrl + path, parameters: params, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: file, name: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, progress: nil, success: { (task, response) in
            weakSelf?.requestSuccess(response: response, successResult: successResult, failureResult: failureResult)
        }) { (task, error) in
            weakSelf?.hideMessage()
            weakSelf?.showDelayToast(message: "未知错误，请重试！")
            failureResult()
        }
    }
    
    //MARK: - 请求成功回调
    func requestSuccess(response: Any?, successResult:@escaping ([String : Any]) -> Void, failureResult:@escaping () -> Void) {
        AntLog(message: "接口返回数据：\(String(describing: response))")
        hideMessage()
        if let data = response as? [String : Any] {
            if let status = data["status"] {
                if status as! Int == 0 {
                    if let content = data["data"] as? [String : Any] {
                        successResult(content)
                    } else {
                        successResult(data)
                    }
                } else {
                    if status as! Int == 1, let msg = data["msg"] as? String {
                        showDelayToast(message: msg)
                    } else if status as! Int == 2, let msg = data["msg"] as? String {
                        showDelayToast(message: msg)
                        isLogin = false
                        userModel = nil
                        ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
                        UserDefaults.standard.removeObject(forKey: kUserInfo)
                        UserDefaults.standard.synchronize()
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        if (delegate.window?.rootViewController?.isKind(of: UITabBarController.classForCoder()))! {
                            let tabbar = delegate.window?.rootViewController as! UITabBarController
                            let nav = tabbar.selectedViewController as! UINavigationController
                            nav.popToRootViewController(animated: false)
                            tabbar.selectedIndex = 0
                        }
                    } else {
                        showDelayToast(message: "未知错误，请重试！")
                    }
                    failureResult()
                }
            } else {
                showDelayToast(message: "未知错误，请重试！")
                failureResult()
            }
        } else {
            showDelayToast(message: "未知错误，请重试！")
            failureResult()
        }
    }
    
    // MARK: - 显示提示
    func showMessage(message : String) {
        if progress == nil {
            progressCount = 0
            progress = MBProgressHUD.showAdded(to: kWindow!, animated: true)
            progress?.label.text = message
        }
        progressCount += 1
    }
    
    // MARK: - 隐藏提示
    func hideMessage() {
        progressCount -= 1
        if progressCount < 0 {
            progressCount = 0
        }
        if (progress != nil) && progressCount == 0 {
            progress?.hide(animated: true)
            progress?.removeFromSuperview()
            progress = nil
        }
    }
    
    // MARK: - 显示固定时间的提示
    func showDelayToast(message : String) {
        let hud = MBProgressHUD.showAdded(to: kWindow!, animated: true)
        hud.detailsLabel.text = message
        hud.mode = .text
        hud.hide(animated: true, afterDelay: 2)
    }
    
}
