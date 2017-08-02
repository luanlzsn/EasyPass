//
//  AppDelegate.swift
//  EasyPass
//
//  Created by luan on 2017/6/25.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .default
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        if UserDefaults.standard.object(forKey: kUserInfo) != nil {
            AntManage.isLogin = true
            AntManage.userModel = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: kUserInfo) as! Data) as? UserModel
        }
        
        initializationShareSDK()
        
        return true
    }
    
    func initializationShareSDK() {
        ShareSDK.registerActivePlatforms([/*SSDKPlatformType.typeSinaWeibo.rawValue,*/SSDKPlatformType.typeWechat.rawValue/*,SSDKPlatformType.typeQQ.rawValue*/], onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform {
                    case SSDKPlatformType.typeSinaWeibo:
                        ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    case SSDKPlatformType.typeWechat:
                        ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    case SSDKPlatformType.typeQQ:
                        ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    default:
                        break
                }
        }, onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform {
//                    case SSDKPlatformType.typeSinaWeibo:
//                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                        appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243", appSecret: "38a4f8204cc784f81f9f0daaf31e02e3", redirectUri: "http://www.sharesdk.cn", authType: SSDKAuthTypeBoth)
                    case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                        appInfo?.ssdkSetupWeChat(byAppId: "wx8c30d0100c7d105e", appSecret: "63b7556c2808b26423e66d44c4c4d9f1")
//                    case SSDKPlatformType.typeQQ:
//                    //设置QQ应用信息
//                        appInfo?.ssdkSetupQQ(byAppId: "100371282",  appKey: "aed9b0303e3ed1e27bae87c33761161d", authType: SSDKAuthTypeBoth)
                    default:
                        break
                }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

