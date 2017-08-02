//
//  PaymentResultsController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class PaymentResultsController: AntController {

    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    var resultsStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if resultsStatus {
            statusImage.image = UIImage(named: "payment_successful")
            statusTitle.text = "支付已成功！"
            oneBtn.setTitle("查看订单", for: .normal)
            twoBtn.setTitle("返回首页", for: .normal)
        } else {
            statusImage.image = UIImage(named: "payment_failure")
            statusTitle.text = "支付失败！"
            oneBtn.setTitle("重新支付", for: .normal)
            twoBtn.setTitle("返回购物车", for: .normal)
        }
    }

    @IBAction func oneBtnClick(_ sender: UIButton) {
        if resultsStatus {
            let nav = navigationController
            nav?.popToRootViewController(animated: false)
            perform(#selector(showMyOrder(nav:)), with: nav!, afterDelay: 0.01)
        } else {
            tabBarController?.selectedIndex = 0
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func twoBtnClick(_ sender: UIButton) {
        if resultsStatus {
            tabBarController?.selectedIndex = 0
            navigationController?.popToRootViewController(animated: false)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showMyOrder(nav: UINavigationController) {
        nav.pushViewController(UIStoryboard(name: "Mine", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyOrder"), animated: true)
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
