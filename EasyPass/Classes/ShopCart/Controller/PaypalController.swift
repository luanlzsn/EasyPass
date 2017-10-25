//
//  PaypalController.swift
//  EasyPass
//
//  Created by luan on 2017/8/11.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class PaypalController: AntController,PayPalPaymentDelegate {
    
    var orderNo = ""//订单号
    var courseArray = [ShopCartModel]()//购物车购买信息
    var orderItemArray = [OrderItemModel]()//我的订单购买信息
    var payPalConfig = PayPalConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Epass"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;

    }

    @IBAction func confirmClick(_ sender: UIButton) {
        var items = [PayPalItem]()
        var tax: Float = 0.0
        for model in courseArray {
            let price = String.init(format: "%.2f", model.coursePrice ?? 0.0)
            let item = PayPalItem(name: model.courseName ?? "", withQuantity: UInt(model.quantity ?? 0), withPrice: NSDecimalNumber(string: price), withCurrency: "CAD", withSku: "\(model.courseId ?? 0)")
            tax += (model.courseOnTax != nil) ? (model.courseOnTax! * Float.init(model.quantity ?? 0)) : 0.0
            items.append(item)
        }
        for model in orderItemArray {
            let price = String.init(format: "%.2f", model.coursePrice ?? 0.0)
            let item = PayPalItem(name: model.courseName ?? "", withQuantity: UInt(model.quantity ?? 0), withPrice: NSDecimalNumber(string: price), withCurrency: "CAD", withSku: "\(model.courseId ?? 0)")
            tax += (model.courseOnTax != nil) ? (model.courseOnTax! * Float.init(model.quantity ?? 0)) : 0.0
            items.append(item)
        }
        let subtotal = PayPalItem.totalPrice(forItems: items)
        let shipping = NSDecimalNumber(string: "0.00")
        let taxNum = NSDecimalNumber(string: String.init(format: "%.2f", tax))
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: taxNum)
        let total = subtotal.adding(shipping).adding(taxNum)
        let payment = PayPalPayment(amount: total, currencyCode: "CAD", shortDescription: "课程购买", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
        present(paymentViewController!, animated: true, completion: nil)
    }
    
    func checkPaypal(completedPayment: PayPalPayment) {
        weak var weakSelf = self
        let response = completedPayment.confirmation["response"] as! [String : Any]
        let createTime = (response["create_time"] as! String).replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        let body = ["id":response["id"]!, "createTime":createTime, "intent":response["intent"]!, "state":response["state"]!, "amount":String.init(format: "%.2f", completedPayment.amount.doubleValue), "currencyCode":completedPayment.currencyCode] as [String : Any]
        AntManage.postCheckPaypal(body: body , orderNo: orderNo, successResult: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(kPaypalPaymentSuccess), object: nil)
            weakSelf?.performSegue(withIdentifier: "PaymentResults", sender: true)
        }, failureResult: {
            weakSelf?.performSegue(withIdentifier: "PaymentResults", sender: false)
        })
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentResults" {
            let paymentResults = segue.destination as! PaymentResultsController
            paymentResults.resultsStatus = sender as! Bool
        }
    }
    
    // MARK: - PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        weak var weakSelf = self
        paymentViewController.dismiss(animated: true) { 
            weakSelf?.performSegue(withIdentifier: "PaymentResults", sender: false)
        }
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        weak var weakSelf = self
        paymentViewController.dismiss(animated: true) {
            weakSelf?.checkPaypal(completedPayment: completedPayment)
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
