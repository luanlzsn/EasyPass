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

    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var reservationBtn: UIButton!
    @IBOutlet weak var lineLeft: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var onTax: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    let editBtn = UIButton(type: UIButtonType.custom)
    var videoArray = [ShopCartModel]()//视频课程数据
    var reservationArray = [ShopCartModel]()//预约课程数据
    var reservationSelectArray = [Int]()//选中的预约课程
    var videoPageNo = 1//视频课程分页信息
    var reservationPageNo = 1//预约课程分页信息
    var videoNoMoreData = false//视频课程是否加载完
    var reservationNoMoreData = false//预约课程是否加载完
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
        
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitle("完成", for: .selected)
        editBtn.setTitleColor(UIColor.black, for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        editBtn.addTarget(self, action: #selector(editShopCartClick), for: .touchUpInside)
        editBtn.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getShoppingCartList(pageNo: 1, tag: (weakSelf!.videoBtn.isSelected ? 0 : 1))
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getShoppingCartList(pageNo: (weakSelf!.videoBtn.isSelected ? weakSelf!.videoPageNo : weakSelf!.reservationPageNo) + 1, tag: (weakSelf!.videoBtn.isSelected ? 0 : 1))
        })
        getShoppingCartList(pageNo: 1, tag: 0)
    }
    
    // MARK: - 视频课程
    @IBAction func videoCourseClick(_ sender: UIButton) {
        sender.isSelected = true
        reservationBtn.isSelected = false
        editBtn.isHidden = true
        lineLeft.constant = 0
        tableBottom.constant = 0
        checkOutView.isHidden = true
        tableView.isEditing = false
        tableView.mj_footer.isHidden = videoNoMoreData
        tableView.reloadData()
    }
    
    // MARK: - 预约课程
    @IBAction func reservationCourseClick(_ sender: UIButton) {
        if Common.checkTouristIsOperation(controller: self) {
            sender.isSelected = true
            videoBtn.isSelected = false
            editBtn.isHidden = false
            tableView.isEditing = editBtn.isSelected
            lineLeft.constant = kScreenWidth / 2.0
            tableBottom.constant = 135
            checkOutView.isHidden = false
            tableView.mj_footer.isHidden = reservationNoMoreData
            tableView.reloadData()
            if reservationArray.count == 0, !reservationNoMoreData {
                getShoppingCartList(pageNo: 1, tag: 1)
            }
        } else {
            AntManage.showDelayToast(message: "请先登录")
        }
    }
    
    // MARK: - 预约课程提交订单
    @IBAction func checkOutClick() {
        if reservationArray.count == 0 || editBtn.isSelected, reservationSelectArray.count == 0 {
            AntManage.showDelayToast(message: "请选择！")
            return
        }
        var totalPrice: Float = 0.0//商品总价
        var totalOnTax: Float = 0.0//商品总税务
        var orderItemList = [[String : Any]]()
        var array = [ShopCartModel]()
        for shopCartModel in reservationArray {
            if !editBtn.isSelected || reservationSelectArray.contains(shopCartModel.id!) {
                array.append(shopCartModel)
                var orderItem = ["shoppingCartId":shopCartModel.id ?? 0 ,"courseId":shopCartModel.courseId ?? 0, "quantity":shopCartModel.quantity ?? 0] as [String : Any]
                let quantity = shopCartModel.quantity ?? 0
                var price: Float = 0.0//商品价格
                var onTax: Float = 0.0//商品税务
                
                if shopCartModel.courseHourId == nil {
                    if shopCartModel.tag == 0 {
                        price = shopCartModel.coursePriceIos ?? 0.0
                    } else {
                        price = shopCartModel.coursePrice ?? 0.0
                    }
                    onTax = shopCartModel.courseOnTax ?? 0.0
                } else {
                    price = shopCartModel.courseHourPriceIos ?? 0.0
                    onTax = shopCartModel.courseHourOnTax ?? 0.0
                    orderItem["courseClassHourId"] = shopCartModel.courseHourId!
                }
                orderItem["price"] = String(format: "%.2f", price)
                orderItem["onTax"] = String(format: "%.2f", onTax)
                totalPrice += price * Float.init(quantity)
                totalOnTax += onTax * Float.init(quantity)
                orderItemList.append(orderItem)
            }
        }
        let orderTotalPrice = String(format: "%.2f", Float(String(format: "%.2f", totalPrice))! + Float(String(format: "%.2f", totalOnTax))!)
        weak var weakSelf = self
        AntManage.postSumbitOrder(body: ["orderItemList":orderItemList, "totalPrice":String(format: "%.2f", totalPrice), "totalOnTax":String(format: "%.2f", totalOnTax), "orderTotalPrice":orderTotalPrice], successResult: { (response) in
            weakSelf?.orderNo = response["orderNo"] as! String
            if weakSelf!.editBtn.isSelected {
                weakSelf?.editShopCartClick()
            }
            weakSelf?.getShoppingCartList(pageNo: 1, tag: 1)
            weakSelf?.performSegue(withIdentifier: "Paypal", sender: array)
        }, failureResult: {})
    }
    
    // MARK: - 编辑购物车
    func editShopCartClick() {
        editBtn.isSelected = !editBtn.isSelected
        tableView.isEditing = editBtn.isSelected
        if !tableView.isEditing {
            reservationSelectArray.removeAll()
        }
        refreshReservationCheckOutView()
        tableView.reloadData()
    }
    
    // MARK: - 请求数据
    func getShoppingCartList(pageNo: Int, tag: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "shoppingcart/getShoppingCartByPage", params: ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20, "tag":tag], successResult: { (response) in
            if tag == 0 {
                weakSelf?.videoPageNo = response["pageNo"] as! Int
                if weakSelf?.videoPageNo == 1 {
                    weakSelf?.videoArray.removeAll()
                }
                if let list = response["list"] as? [[String : Any]] {
                    weakSelf?.videoArray += Mapper<ShopCartModel>().mapArray(JSONArray: list)
                }
                weakSelf?.videoNoMoreData = (weakSelf!.videoPageNo >= (response["totalPage"] as! Int))
            } else {
                weakSelf?.reservationPageNo = response["pageNo"] as! Int
                if weakSelf?.reservationPageNo == 1 {
                    weakSelf?.reservationArray.removeAll()
                }
                if let list = response["list"] as? [[String : Any]] {
                    weakSelf?.reservationArray += Mapper<ShopCartModel>().mapArray(JSONArray: list)
                }
                weakSelf?.reservationNoMoreData = (weakSelf!.reservationPageNo >= (response["totalPage"] as! Int))
                weakSelf?.refreshReservationCheckOutView()
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = weakSelf!.videoBtn.isSelected ? weakSelf!.videoNoMoreData : weakSelf!.reservationNoMoreData
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    // MARK: - 更新购物车数据
    func refreshShopCart() {
        getShoppingCartList(pageNo: 1, tag: 0)
        getShoppingCartList(pageNo: 1, tag: 1)
    }
    
    // MARK: - 刷新预约课程选中信息
    func refreshReservationCheckOutView() {
        var totalPrice: Float = 0.0//商品总价
        var totalOnTax: Float = 0.0//商品总税务
        for model in reservationArray {
            if !editBtn.isSelected || reservationSelectArray.contains(model.id!) {
                let price: Float = model.coursePrice ?? 0.0
                let onTax: Float = model.courseOnTax ?? 0.0
                let quantity = model.quantity ?? 0
                totalPrice += price * Float.init(quantity)
                totalOnTax += onTax * Float.init(quantity)
            }
        }
        totalMoney.text = "$\(totalPrice)"
        onTax.text = "$\(totalOnTax)"
        orderMoney.text = "$\(totalPrice + totalOnTax)"
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
        AntManage.postRequest(path: "applePay/setIapCertificate", params: ["token":AntManage.userModel!.token!, "orderNo":orderNo, "receipt":receipt, "chooseEnv":true], successResult: { (response) in
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
        } else if segue.identifier == "Paypal" {
            let paypal = segue.destination as! PaypalController
            paypal.orderNo = orderNo
            paypal.courseArray = sender as! [ShopCartModel]
        }
    }
    
    // MARK: - ShopCart_Delegate
    func reduceNumber(row: Int) {
        weak var weakSelf = self
        let shopCartModel = reservationArray[row]
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
            if weakSelf!.reservationBtn.isSelected {
                weakSelf?.refreshReservationCheckOutView()
            }
        }, failureResult: {})
    }
    
    func addNumber(row: Int) {
        weak var weakSelf = self
        let shopCartModel = reservationArray[row]
        var params = ["token":AntManage.userModel!.token!, "courseId":shopCartModel.courseId!, "number":1, "add":false] as [String : Any]
        if shopCartModel.courseHourId != nil {
            params["classHourId"] = shopCartModel.courseHourId!
        }
        AntManage.postRequest(path: "shoppingcart/addOrUpdateShoppingCart", params: params, successResult: { (_) in
            shopCartModel.quantity = shopCartModel.quantity! + 1
            weakSelf?.tableView.reloadData()
            if weakSelf!.reservationBtn.isSelected {
                weakSelf?.refreshReservationCheckOutView()
            }
        }, failureResult: {})
    }
    
    func deleteShopCart(row: Int) {
        weak var weakSelf = self
        let shopCartModel = videoBtn.isSelected ? videoArray[row] : reservationArray[row]
        AntManage.postRequest(path: "shoppingcart/deleteShoppingCart", params: ["token":AntManage.userModel!.token!, "ids":shopCartModel.id!], successResult: { (response) in
            if weakSelf!.videoBtn.isSelected {
                weakSelf?.videoArray.remove(at: row)
            } else {
                weakSelf?.reservationArray.remove(at: row)
                if (weakSelf?.reservationSelectArray.contains(shopCartModel.id!))! {
                    weakSelf?.reservationSelectArray.remove(at: weakSelf!.reservationSelectArray.index(of: shopCartModel.id!)!)
                }
                weakSelf?.refreshReservationCheckOutView()
            }
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    func checkOut(row: Int) {
        if AntManage.isTourist {
            let alert = UIAlertController(title: "购买课程", message: "登录易Pass购买，可跨平台观看视频，直接购买，只能在当前设备上观看视频", preferredStyle: .alert)
            weak var weakSelf = self
            alert.addAction(UIAlertAction(title: "登录易Pass购买", style: .destructive, handler: { (_) in
                _ = Common.checkTouristIsOperation(controller: weakSelf!)
            }))
            alert.addAction(UIAlertAction(title: "游客身份购买", style: .default, handler: { (_) in
                weakSelf?.paymentVideoCourse(row: row)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            paymentVideoCourse(row: row)
        }
    }
    
    // MARK: - 购买视频课程
    func paymentVideoCourse(row: Int) {
        let shopCartModel = videoArray[row]
        var orderItemList = ["shoppingCartId":shopCartModel.id! ,"courseId":shopCartModel.courseId!, "quantity":shopCartModel.quantity!] as [String : Any]
        var appleProductId = ""
        let quantity = (shopCartModel.quantity != nil) ? shopCartModel.quantity! : 0
        var price: Float = 0.0//商品价格
        var onTax: Float = 0.0//商品税务
        
        if shopCartModel.courseHourId == nil {
            if shopCartModel.tag == 0 {
                price = shopCartModel.coursePriceIos ?? 0.0
            } else {
                price = shopCartModel.coursePrice ?? 0.0
            }
            onTax = shopCartModel.courseOnTax ?? 0.0
            appleProductId = shopCartModel.appleProductIdForCourse!
        } else {
            price = shopCartModel.courseHourPriceIos ?? 0.0
            onTax = shopCartModel.courseHourOnTax ?? 0.0
            orderItemList["courseClassHourId"] = shopCartModel.courseHourId!
            appleProductId = shopCartModel.appleProductIdForCourseHour ?? ""
        }
        orderItemList["price"] = String(format: "%.2f", price)
        orderItemList["onTax"] = String(format: "%.2f", onTax)
        let totalPrice = String(format: "%.2f", price * Float.init(quantity))
        let totalOnTax = String(format: "%.2f", onTax * Float.init(quantity))
        let orderTotalPrice = String(format: "%.2f", Float(totalPrice)! + Float(totalOnTax)!)
        
        weak var weakSelf = self
        AntManage.postSumbitOrder(body: ["orderItemList":[orderItemList], "totalPrice":totalPrice, "totalOnTax":totalOnTax, "orderTotalPrice":orderTotalPrice], successResult: { (response) in
            AntManage.showDelayToast(message: "订单提交成功！")
            weakSelf?.orderNo = response["orderNo"] as! String
            weakSelf?.orderNum = quantity
            weakSelf?.videoArray.remove(at: row)
            weakSelf?.tableView.reloadData()
            weakSelf?.buyCourseWithIAP(appleProductId: appleProductId)
        }, failureResult: {})
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoBtn.isSelected ? videoArray.count : reservationArray.count
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
        let shopCartModel = videoBtn.isSelected ? videoArray[indexPath.row] : reservationArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: shopCartModel.photo!), placeholderImage: UIImage(named: "default_image"))
        if shopCartModel.tag == 0 {
            cell.reduceBtn.isHidden = true
            cell.addBtn.isHidden = true
            cell.checkOutBtn.isHidden = false
            if shopCartModel.courseHourId != nil {
                cell.courseName.text = (shopCartModel.gradeName ?? "") + "\n\n" + (shopCartModel.lessonPeriod ?? "") + " " + (shopCartModel.classHourName ?? "")
                cell.money.text = "$" + "\(shopCartModel.courseHourPriceIos ?? 0.0)"
                cell.numberTextField.text = "\(shopCartModel.quantity ?? 0)"
            } else {
                cell.courseName.text = (shopCartModel.gradeName ?? "") + "\n\n" + (shopCartModel.courseName ?? "")
                cell.money.text = "$" + "\(shopCartModel.coursePriceIos ?? 0.0)"
                cell.numberTextField.text = "\(shopCartModel.quantity ?? 0)"
            }
        } else {
            if tableView.isEditing {
                if reservationSelectArray.contains(shopCartModel.id!) {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            cell.reduceBtn.isHidden = false
            cell.addBtn.isHidden = false
            cell.checkOutBtn.isHidden = true
            cell.courseName.text = (shopCartModel.gradeName ?? "") + "\n\(shopCartModel.courseName ?? "")\n预约课程 " + (shopCartModel.teacher ?? "")
            cell.money.text = "$" + "\(shopCartModel.coursePrice ?? 0.0)"
            cell.numberTextField.text = "\(shopCartModel.quantity ?? 0)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let shopCartModel = reservationArray[indexPath.row]
            if !reservationSelectArray.contains(shopCartModel.id!) {
                reservationSelectArray.append(shopCartModel.id!)
                refreshReservationCheckOutView()
            }
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.courseId = videoBtn.isSelected ? videoArray[indexPath.row].courseId! : reservationArray[indexPath.row].courseId!
        navigationController?.pushViewController(courseDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let shopCartModel = reservationArray[indexPath.row]
            if reservationSelectArray.contains(shopCartModel.id!) {
                reservationSelectArray.remove(at: reservationSelectArray.index(of: shopCartModel.id!)!)
                refreshReservationCheckOutView()
            }
        }
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
