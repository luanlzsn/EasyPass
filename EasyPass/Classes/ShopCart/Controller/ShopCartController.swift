//
//  ShopCartController.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class ShopCartController: AntController,UITableViewDelegate,UITableViewDataSource,ShopCart_Delegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var onTax: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    var shopCartArray = [ShopCartModel]()
    var pageNo = 1
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshShopCart), name: NSNotification.Name(kAddShopCartSuccess), object: nil)
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

    @IBAction func checkOutClick() {
        
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
                cell.courseName.text = shopCartModel.gradeName! + "\n" + shopCartModel.courseName! + "\n" + shopCartModel.lessonPeriod! + " " + shopCartModel.classHourName!
                cell.money.text = "$" + "\(shopCartModel.courseHourPrice!)"
                cell.numberTextField.text = "\(shopCartModel.quantity!)"
            } else {
                cell.courseName.text = shopCartModel.gradeName! + "\n" + shopCartModel.courseName!
                cell.money.text = "$" + "\(shopCartModel.coursePrice!)"
                cell.numberTextField.text = "\(shopCartModel.quantity!)"
            }
        } else {
            cell.courseName.text = shopCartModel.gradeName! + "\n" + shopCartModel.courseName! + "\n线下预约 " + shopCartModel.teacher!
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
