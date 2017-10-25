//
//  AntTabBarController.swift
//  EasyPass
//
//  Created by luan on 2017/8/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class AntTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabBar.isTranslucent = false
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (!AntManage.isLogin && viewController == viewControllers?[1]) || (AntManage.isLogin && (viewController == viewControllers?[3] && AntManage.isTourist)) {
            present(UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()!, animated: true, completion: nil)
            return false
        }
        return true
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
