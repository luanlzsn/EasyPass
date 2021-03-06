//
//  LeomanDefault.swift
//  MoFan
//
//  Created by luan on 2016/12/8.
//  Copyright © 2016年 luan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import YYCategories
import MJExtension

func AntLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("类\(fileName as NSString)的\(methodName)方法第\(lineNumber)行:\(message)");
    #endif
}

let kWindow = UIApplication.shared.keyWindow
let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = kScreenBounds.width
let kScreenHeight = kScreenBounds.height
let MainColor = Common.colorWithHexString(colorStr: "63BEB7")
let kIphone4 = kScreenHeight == 480
let kIpad = UIDevice.current.userInterfaceIdiom == .pad
let kAppDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//let kRequestBaseUrl = "http://175.102.18.82:8083/easypass-app/"
let kRequestBaseUrl = "http://epass.epassstudy.com:8080/easypass-app/"
//let kRequestBaseUrl = "http://10.58.177.192:8080/easypass-app/"

let kAppVersion_URL = "http://itunes.apple.com/lookup?id=1258792640"//获取版本信息
let kAppDownloadURL = "https://itunes.apple.com/cn/app/id1258792640"//下载地址

let kShareUrl = URL(string: "http://www.epassstudy.com/")!
let kShareContent = "Epass致力于利用科学的学习方法和线上教育的优势，为学生打造一个在家就可以独立学习的机会，为广大学子的求学求职之路点一盏明灯。毕竟，行路，还是要靠行路人自己。"

let kIsTourist = "kIsTourist"//是否是游客
let kUserInfo = "kUserInfo"//登录用户的信息

let kLoginStatusUpdate = "kLoginStatusUpdate"//登录状态更新通知
let kAddShopCartSuccess = "kAddShopCartSuccess"//添加购物车成功通知
let kPaypalPaymentSuccess = "kPaypalPaymentSuccess"//Paypal支付成功通知


struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

typealias ConfirmBlock = (_ value: Any) ->()
typealias CancelBlock = () ->()

