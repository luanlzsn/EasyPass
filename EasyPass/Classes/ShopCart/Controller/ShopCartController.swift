//
//  ShopCartController.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper
import StoreKit

class ShopCartController: AntController,UITableViewDelegate,UITableViewDataSource,ShopCart_Delegate,SKPaymentTransactionObserver,SKProductsRequestDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var onTax: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    var shopCartArray = [ShopCartModel]()
    var pageNo = 1
    var receipt = ""//支付凭证
    var orderNo = ""//支付订单号
    var orderNum = 0//订单商品的数量
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        SKPaymentQueue.default().remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshShopCart), name: NSNotification.Name(kAddShopCartSuccess), object: nil)
        SKPaymentQueue.default().add(self)
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getShoppingCartList(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getShoppingCartList(pageNo: weakSelf!.pageNo + 1)
        })
        getShoppingCartList(pageNo: 1)
    }
    
    func getShoppingCartList(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "shoppingcart/getShoppingCartByPage", params: ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20], successResult: { (response) in
            weakSelf?.pageNo = response["pageNo"] as! Int
            if weakSelf?.pageNo == 1 {
                weakSelf?.shopCartArray.removeAll()
            }
            weakSelf?.shopCartArray += Mapper<ShopCartModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.pageNo >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    func refreshShopCart() {
        getShoppingCartList(pageNo: 1)
    }
    
    // MARK: - 内购
    func buyCourseWithIAP(appleProductId: String) {
        if SKPaymentQueue.canMakePayments() {
            let set = NSSet(object: appleProductId)
            let request = SKProductsRequest(productIdentifiers: set as! Set<String>)
            request.delegate = self
            request.start()
            AntManage.showMessage(message: "正在获取商品信息，请稍后")
        } else {
            AntManage.showDelayToast(message: "您禁止了应用内付费购买！")
        }
    }
    
    // MARK: - 二次校验
    func checkReceiptIsValid() {
        weak var weakSelf = self
        AntManage.postRequest(path: "applePay/setIapCertificate", params: ["token":AntManage.userModel!.token!, "orderNo":orderNo, "receipt":receipt, "chooseEnv":false], successResult: { (response) in
            weakSelf?.performSegue(withIdentifier: "PaymentResults", sender: true)
        }, failureResult: {
            weakSelf?.performSegue(withIdentifier: "PaymentResults", sender: false)
        })
    }

    @IBAction func checkOutClick() {
        
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentResults" {
            let paymentResults = segue.destination as! PaymentResultsController
            paymentResults.resultsStatus = sender as! Bool
        }
    }
    
    // MARK: - ShopCart_Delegate
    func reduceNumber(row: Int) {
        weak var weakSelf = self
        let shopCartModel = shopCartArray[row]
        if shopCartModel.quantity == 1 {
            return
        }
        var params = ["token":AntManage.userModel!.token!, "courseId":shopCartModel.courseId!, "number":-1, "add":false] as [String : Any]
        if shopCartModel.courseHourId != nil {
            params["classHourId"] = shopCartModel.courseHourId!
        }
        AntManage.postRequest(path: "shoppingcart/addOrUpdateShoppingCart", params: params, successResult: { (_) in
            shopCartModel.quantity = shopCartModel.quantity! - 1
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    func addNumber(row: Int) {
        weak var weakSelf = self
        let shopCartModel = shopCartArray[row]
        var params = ["token":AntManage.userModel!.token!, "courseId":shopCartModel.courseId!, "number":1, "add":false] as [String : Any]
        if shopCartModel.courseHourId != nil {
            params["classHourId"] = shopCartModel.courseHourId!
        }
        AntManage.postRequest(path: "shoppingcart/addOrUpdateShoppingCart", params: params, successResult: { (_) in
            shopCartModel.quantity = shopCartModel.quantity! + 1
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    func deleteShopCart(row: Int) {
        weak var weakSelf = self
        let shopCartModel = shopCartArray[row]
        AntManage.postRequest(path: "shoppingcart/deleteShoppingCart", params: ["token":AntManage.userModel!.token!, "ids":shopCartModel.id!], successResult: { (response) in
            weakSelf?.shopCartArray.remove(at: row)
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    func checkOut(row: Int) {
        let shopCartModel = shopCartArray[row]
        var totalPrice: Float = 0.0
        var totalOnTax: Float = 0.0
        var orderItemList = ["shoppingCartId":shopCartModel.id! ,"courseId":shopCartModel.courseId!, "quantity":shopCartModel.quantity!] as [String : Any]
        var appleProductId = ""
        if shopCartModel.courseHourId == nil {
            orderItemList["price"] = (shopCartModel.coursePrice != nil) ? shopCartModel.coursePrice! : 0.0
            orderItemList["onTax"] = shopCartModel.courseOnTax!
            totalPrice = shopCartModel.coursePrice! * Float.init(shopCartModel.quantity!)
            totalOnTax = shopCartModel.courseOnTax! * Float.init(shopCartModel.quantity!)
            appleProductId = shopCartModel.appleProductIdForCourse!
        } else {
            orderItemList["price"] = (shopCartModel.courseHourPrice != nil) ? shopCartModel.courseHourPrice! : 0.0
            orderItemList["onTax"] = shopCartModel.courseHourOnTax!
            orderItemList["courseClassHourId"] = shopCartModel.courseHourId!
            appleProductId = shopCartModel.appleProductIdForCourseHour!
        }
        weak var weakSelf = self
        AntManage.postSumbitOrder(body: ["orderItemList":[orderItemList], "totalPrice":totalPrice, "totalOnTax":totalOnTax, "orderTotalPrice":totalPrice + totalOnTax], successResult: { (response) in
            AntManage.showDelayToast(message: "订单提交成功！")
            weakSelf?.orderNo = response["orderNo"] as! String
            weakSelf?.orderNum = shopCartModel.quantity!
            weakSelf?.shopCartArray.remove(at: row)
            weakSelf?.tableView.reloadData()
            weakSelf?.buyCourseWithIAP(appleProductId: appleProductId)
        }, failureResult: {})
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopCartArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopCartCell = tableView.dequeueReusableCell(withIdentifier: "ShopCartCell", for: indexPath) as! ShopCartCell
        cell.delegate = self
        cell.tag = indexPath.row
        let shopCartModel = shopCartArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: shopCartModel.photo!), placeholderImage: UIImage(named: "default_image"))
        if shopCartModel.tag == 0 {
            if shopCartModel.courseHourId != nil {
                cell.courseName.text = shopCartModel.gradeName! + "\n\n" + shopCartModel.lessonPeriod! + " " + shopCartModel.classHourName!
                cell.money.text = "$" + "\((shopCartModel.courseHourPrice != nil) ? shopCartModel.courseHourPrice! : 0.0)"
                cell.numberTextField.text = "\(shopCartModel.quantity!)"
            } else {
                cell.courseName.text = shopCartModel.gradeName! + "\n\n" + shopCartModel.courseName!
                cell.money.text = "$" + "\((shopCartModel.coursePrice != nil) ? shopCartModel.coursePrice! : 0.0)"
                cell.numberTextField.text = "\(shopCartModel.quantity!)"
            }
        } else {
            cell.courseName.text = shopCartModel.gradeName! + "\n\n预约课程 " + shopCartModel.teacher!
            cell.money.text = "$" + "\(shopCartModel.coursePrice!)"
            cell.numberTextField.text = "\(shopCartModel.quantity!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.courseId = shopCartArray[indexPath.row].courseId!
        navigationController?.pushViewController(courseDetail, animated: true)
    }
    
    // MARK: - SKProductsRequestDelegate
    // MARK: - 查询成功回调
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        AntManage.hideMessage()
        if response.products.count == 0 {
            AntManage.showDelayToast(message: "无法获取产品信息，请重试！")
            return
        }
        let payment = SKMutablePayment(product: response.products.first!)
        payment.quantity = orderNum
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - 查询失败回调
    func request(_ request: SKRequest, didFailWithError error: Error) {
        AntManage.hideMessage()
        AntManage.showDelayToast(message: error.localizedDescription)
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        AntManage.hideMessage()
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                AntManage.hideMessage()
                completeTransaction(transaction: transaction)
                receipt = try! Data(contentsOf: Bundle.main.appStoreReceiptURL!).base64EncodedString()
                checkReceiptIsValid()
                break
            case .failed:
                AntManage.hideMessage()
                failedTransaction(transaction: transaction)
                break
            case .restored:
                AntManage.hideMessage()
                restoreTransaction(transaction: transaction)
                break
            case .purchasing:
                AntManage.showMessage(message: "正在请求付费信息，请稍后")
                break
            default:
                break
            }
        }
    }
    
    func completeTransaction(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func failedTransaction(transaction: SKPaymentTransaction) {
        let error = transaction.error! as NSError
        if error.code != SKError.paymentCancelled.rawValue {
            performSegue(withIdentifier: "PaymentResults", sender: false)
        } else {
            AntManage.showDelayToast(message: "取消交易")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restoreTransaction(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
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
