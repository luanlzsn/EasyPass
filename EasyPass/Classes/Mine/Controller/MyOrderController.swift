//
//  MyOrderController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MyOrderController: AntController,UITableViewDelegate,UITableViewDataSource,MyOrder_Delegate {

    @IBOutlet weak var allCourseBtn: UIButton!
    @IBOutlet weak var orderStatusBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var orderArray = [OrderModel]()
    var orderPage = 1
    var classifyModel: ClassifyModel?//选择的专业
    var grade = 0//年级
    var orderStatus = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func searchClick() {
        
    }
    
    func getOrderByPage(pageNo: Int) {
        weak var weakSelf = self
        var params = ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20] as [String : Any]
        if classifyModel != nil {
            params["classifyId"] = classifyModel!.id!
        }
        if grade != 0 {
            params["grade"] = grade
        }
        if orderStatus != -1 {
            params["orderStatus"] = orderStatus
        }
        AntManage.postRequest(path: "order/getOrderList", params:params , successResult: { (response) in
            weakSelf?.orderPage = response["pageNo"] as! Int
            if weakSelf?.orderPage == 1 {
                weakSelf?.orderArray.removeAll()
            }
            weakSelf?.orderArray += Mapper<OrderModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
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
    
    // MARK: - MyOrder_Delegate
    func cancelOrder(section: Int) {
        let alert = UIAlertController(title: "提示", message: "是否确定取消该订单？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        weak var weakSelf = self
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let order = weakSelf?.orderArray[section]
            AntManage.postRequest(path: "order/deleteOrder", params: ["token":AntManage.userModel!.token!, "orderNos":order!.orderNo!], successResult: { (response) in
                weakSelf?.orderArray.remove(at: section)
                weakSelf?.tableView.reloadData()
            }, failureResult: {})
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyOrderCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        cell.delegate = self
        cell.tag = indexPath.section
        let order = orderArray[indexPath.section]
        cell.courseImage.sd_setImage(with: URL(string: (order.photo != nil) ? order.photo! : ""), placeholderImage: UIImage(named: "default_image"))
        if order.courseHourId != nil {
            cell.courseName.text = order.classHourName
            cell.courseCredit.text = "学分0"
            cell.money.text = "$" + "\(order.courseHourPrice!)"
            cell.classHour.text = "/1课时"
            for image in cell.starArray {
                image.image = UIImage(named: "star_unselect")
            }
        } else {
            cell.courseName.text = order.courseName
            cell.courseCredit.text = "学分\(order.credit!)"
            cell.money.text = "$" + "\(order.coursePrice!)"
            cell.classHour.text = "/\(order.classHour!)课时"
            for image in cell.starArray {
                if order.difficulty! > image.tag - 100 {
                    image.image = UIImage(named: "star_select")
                } else {
                    image.image = UIImage(named: "star_unselect")
                }
            }
        }
        if order.tag == 0 {
            cell.typeImage.image = UIImage(named: "video_course")
        } else if order.tag == 1 {
            cell.typeImage.image = UIImage(named: "reservation_course")
        } else {
            cell.typeImage.image = UIImage(named: "study_group")
        }
        cell.number.text = "x \(order.quantity!)"
        if order.orderStatus == 0 {
            cell.alreadyPaid.isHidden = true
            cell.cancelOrderBtn.isHidden = false
        } else {
            cell.alreadyPaid.isHidden = false
            cell.cancelOrderBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.courseId = orderArray[indexPath.section].courseId!
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
