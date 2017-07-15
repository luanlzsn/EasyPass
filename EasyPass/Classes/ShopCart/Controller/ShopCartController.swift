//
//  ShopCartController.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class ShopCartController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var onTax: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    var courseArray = [CourseModel]()
    var pageNo = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        weak var weakSelf = self
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
//            weakSelf?.getShoppingCartList(pageNo: 1)
//        })
//        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
//            weakSelf?.getShoppingCartList(pageNo: weakSelf!.pageNo + 1)
//        })
        getShoppingCartList(pageNo: 1)
    }
    
    func getShoppingCartList(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "shoppingcart/getShoppingCartByPage", params: ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20], successResult: { (response) in
//            weakSelf?.pageNo = response["pageNo"] as! Int
//            if weakSelf?.pageNo == 1 {
//                weakSelf?.courseArray.removeAll()
//            }
            weakSelf?.courseArray += Mapper<CourseModel>().mapArray(JSONArray: response["courseList"] as! [[String : Any]])
//            weakSelf?.tableView.mj_header.endRefreshing()
//            weakSelf?.tableView.mj_footer.endRefreshing()
//            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.pageNo >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
//            weakSelf?.tableView.mj_header.endRefreshing()
//            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }

    @IBAction func checkOutClick() {
        
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopCartCell = tableView.dequeueReusableCell(withIdentifier: "ShopCartCell", for: indexPath) as! ShopCartCell
        let courseModel = courseArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: courseModel.photo!))
        cell.courseName.text = courseModel.courseName! + "\n\(courseModel.teacher!) \(courseModel.teacherDesc!)"
        cell.money.text = "$" + "\(courseModel.shoppingCartPrice!)"
        cell.numberTextField.text = "\(courseModel.shoppingCartQuantity!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.isCourse = true
        courseDetail.courseId = courseArray[indexPath.row].id!
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
