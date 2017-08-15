//
//  MyOrderController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper
import StoreKit

class MyOrderController: AntController,UITableViewDelegate,UITableViewDataSource,OrderBuyTime_Delegate,SKPaymentTransactionObserver,SKProductsRequestDelegate {

    @IBOutlet weak var allCourseBtn: UIButton!
    @IBOutlet weak var orderStatusBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var orderArray = [OrderModel]()
    var orderPage = 1
    var classifyModel: ClassifyModel?//选择的专业
    var grade = 0//年级
    var orderStatus = -1
    var name = ""
    
    var receipt = ""//支付凭证
    var orderNo = ""//支付订单号
    var orderNum = 0//订单商品的数量
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        SKPaymentQueue.default().remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(paymentSuccess), name: NSNotification.Name(kPaypalPaymentSuccess), object: nil)
        SKPaymentQueue.default().add(self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf?.getOrderByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.getOrderByPage(pageNo: weakSelf!.orderPage + 1)
        })
        getOrderByPage(pageNo: 1)
    }
    
    // MARK: - 支付成功
    func paymentSuccess() {
        getOrderByPage(pageNo: 1)
    }
    
    func searchClick() {
        let alert = UIAlertController(title: "提示", message: "输入搜索内容", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "请输入搜索内容"
        }
        weak var weakSelf = self
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let textField = alert.textFields?.first
            weakSelf?.name = textField!.text!
            weakSelf?.getOrderByPage(pageNo: 1)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getOrderByPage(pageNo: Int) {
        weak var weakSelf = self
        var params = ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20, "name":name] as [String : Any]
        if classifyModel != nil {
            params["classifyId"] = classifyModel!.id!
        }
        if grade != 0 {
            params["grade"] = grade
        }
        if orderStatus != -1 {
            params["orderStatus"] = orderStatus
        }
        AntManage.postRequest(path: "order/getOrderDataList", params:params , successResult: { (response) in
            weakSelf?.orderPage = response["pageNo"] as! Int
            if weakSelf?.orderPage == 1 {
                weakSelf?.orderArray.removeAll()
            }
            if response["list"] != nil, ((response["list"] as? [[String : Any]]) != nil) {
                weakSelf?.orderArray += Mapper<OrderModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.orderPage >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    @IBAction func allCourseClick(_ sender: UIButton) {
        sender.isSelected = true
        orderStatusBtn.isSelected = false
        let courseMenu = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseMenu") as! CourseMenuController
        courseMenu.modalPresentationStyle = .overCurrentContext
        courseMenu.modalTransitionStyle = .crossDissolve
        courseMenu.selectClassify = classifyModel
        courseMenu.selectGrade = grade
        weak var weakSelf = self
        courseMenu.changeSelect = {(response) -> () in
            if let dic = response as? [String : Any] {
                weakSelf?.classifyModel = dic["Classify"] as? ClassifyModel
                weakSelf?.grade = dic["Grade"] as! Int
            } else {
                weakSelf?.classifyModel = nil
                weakSelf?.grade = 0
            }
            weakSelf?.getOrderByPage(pageNo: 1)
        }
        present(courseMenu, animated: true, completion: nil)
    }
    
    @IBAction func orderStatusClick(_ sender: UIButton) {
        sender.isSelected = true
        allCourseBtn.isSelected = false
        let actionSheet = UIAlertController(title: "筛选订单", message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        actionSheet.addAction(UIAlertAction(title: "未支付", style: .default, handler: { (_) in
            weakSelf?.orderStatus = 0
            weakSelf?.getOrderByPage(pageNo: 1)
        }))
        actionSheet.addAction(UIAlertAction(title: "已支付", style: .default, handler: { (_) in
            weakSelf?.orderStatus = 1
            weakSelf?.getOrderByPage(pageNo: 1)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
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
            weakSelf?.getOrderByPage(pageNo: 1)
            weakSelf?.showPaymentResults(true)
        }, failureResult: {
            weakSelf?.showPaymentResults(false)
        })
    }
    
    // MARK: - 显示支付结果
    func showPaymentResults(_ results: Bool) {
        let paymentResults = UIStoryboard(name: "ShopCart", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentResults") as! PaymentResultsController
        paymentResults.resultsStatus = results
        navigationController?.pushViewController(paymentResults, animated: true)
    }
    
    // MARK: - OrderBuyTime_Delegate
    func paymentClick(_ section: Int) {
        let order = orderArray[section]
        if order.orderDetail?.count == 1 {
            let orderItem = (order.orderDetail?.first)!
            if orderItem.tag == 0 {
                var appleProductId = ""
                orderNum = orderItem.quantity!
                orderNo = order.orderNo!
                if orderItem.courseHourId != nil {
                    appleProductId = orderItem.appleProductIdForCourseHour!
                } else {
                    appleProductId = orderItem.appleProductIdForCourse!
                }
                buyCourseWithIAP(appleProductId: appleProductId)
            } else {
                let paypal = UIStoryboard(name: "ShopCart", bundle: Bundle.main).instantiateViewController(withIdentifier: "Paypal") as! PaypalController
                paypal.orderNo = order.orderNo!
                paypal.orderItemArray = order.orderDetail!
                navigationController?.pushViewController(paypal, animated: true)
            }
        } else {
            let paypal = UIStoryboard(name: "ShopCart", bundle: Bundle.main).instantiateViewController(withIdentifier: "Paypal") as! PaypalController
            paypal.orderNo = order.orderNo!
            paypal.orderItemArray = order.orderDetail!
            navigationController?.pushViewController(paypal, animated: true)
        }
    }
    
    func cancelOrderClick(_ section: Int) {
        let alert = UIAlertController(title: "提示", message: "是否确定取消该订单？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        weak var weakSelf = self
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let order = weakSelf?.orderArray[section]
            AntManage.postRequest(path: "order/deleteOrder", params: ["token":AntManage.userModel!.token!, "orderNos":order!.orderNo!], successResult: { (response) in
                weakSelf?.orderArray.remove(at: section)
                weakSelf?.tableView.reloadData()
                weakSelf?.getOrderByPage(pageNo: 1)
            }, failureResult: {})
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderArray[section].orderDetail != nil) ? orderArray[section].orderDetail!.count + 2 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row > orderArray[indexPath.section].orderDetail!.count {
            return 45
        } else {
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orderArray[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNumCell", for: indexPath)
            cell.textLabel?.text = "订单编号:\((order.orderNo != nil) ? order.orderNo! : "")"
            return cell
        } else if indexPath.row <= order.orderDetail!.count {
            let cell: MyOrderCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            let orderItem = order.orderDetail![indexPath.row - 1]
            cell.courseImage.sd_setImage(with: URL(string: (orderItem.photo != nil) ? orderItem.photo! : ""), placeholderImage: UIImage(named: "default_image"))
            if orderItem.courseHourId != nil {
                cell.courseName.text = orderItem.lessonPeriod! + " " + orderItem.classHourName!
                cell.money.text = "$" + ((orderItem.courseHourPriceIos != nil) ? "\(orderItem.courseHourPriceIos!)" : "0.0")
                cell.classHour.text = "/1课时"
            } else {
                cell.courseName.text = orderItem.courseName
                if orderItem.tag == 0 {
                    cell.money.text = "$" + ((orderItem.coursePriceIos != nil) ? "\(orderItem.coursePriceIos!)" : "0.0")
                } else {
                    cell.money.text = "$" + ((orderItem.coursePrice != nil) ? "\(orderItem.coursePrice!)" : "0.0")
                }
                cell.classHour.text = "/\(orderItem.classHour!)课时"
            }
            cell.courseCredit.text = "学分\(orderItem.credit!)"
            for image in cell.starArray {
                if orderItem.difficulty! > image.tag - 100 {
                    image.image = UIImage(named: "star_select")
                } else {
                    image.image = UIImage(named: "star_unselect")
                }
            }
            if orderItem.tag == 0 {
                cell.typeImage.image = UIImage(named: "video_course")
            } else if orderItem.tag == 1 {
                cell.typeImage.image = UIImage(named: "reservation_course")
            } else {
                cell.typeImage.image = UIImage(named: "study_group")
            }
            cell.number.text = "x \(orderItem.quantity!)"
            return cell
        } else {
            let cell: OrderBuyTimeCell = tableView.dequeueReusableCell(withIdentifier: "OrderBuyTimeCell", for: indexPath) as! OrderBuyTimeCell
            cell.delegate = self
            cell.tag = indexPath.section
            if order.orderStatus == 0 {
                cell.cancelBtn.isHidden = false
                cell.buyTime.isHidden = true
                cell.buyTime.text = ""
                if order.orderDetail?.count == 1 {
                    cell.paymentBtn.isHidden = false
                    cell.prompt.isHidden = true
                } else {
                    var isHaveVideoCourse = false//是否有视频课程
                    for item in order.orderDetail! {
                        if item.tag == 0 {
                            isHaveVideoCourse = true
                            break
                        }
                    }
                    cell.paymentBtn.isHidden = isHaveVideoCourse
                    cell.prompt.isHidden = !isHaveVideoCourse
                }
            } else {
                cell.paymentBtn.isHidden = true
                cell.cancelBtn.isHidden = true
                cell.buyTime.isHidden = false
                cell.prompt.isHidden = true
                cell.buyTime.text = "已支付"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
//        courseDetail.courseId = orderArray[indexPath.section].courseId!
//        navigationController?.pushViewController(courseDetail, animated: true)
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
            showPaymentResults(false)
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
