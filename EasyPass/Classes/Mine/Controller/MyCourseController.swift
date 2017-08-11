//
//  MyCourseController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MyCourseController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var allCourseBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var courseArray = [OrderModel]()
    var coursePage = 1
    var classifyModel: ClassifyModel?//选择的专业
    var grade = 0//年级
    var name = ""
    var timeSort = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf?.getMyCourseByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.getMyCourseByPage(pageNo: weakSelf!.coursePage + 1)
        })
        getMyCourseByPage(pageNo: 1)
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
            weakSelf?.getMyCourseByPage(pageNo: 1)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getMyCourseByPage(pageNo: Int) {
        weak var weakSelf = self
        var params = ["token":AntManage.userModel!.token!, "orderStatus":1, "pageNo":pageNo, "pageSize":20, "name":name] as [String : Any]
        if classifyModel != nil {
            params["classifyId"] = classifyModel!.id!
        }
        if grade != 0 {
            params["grade"] = grade
        }
        if !timeSort.isEmpty {
            params["timeSort"] = timeSort
        }
        AntManage.postRequest(path: "order/getOrderList", params:params , successResult: { (response) in
            weakSelf?.coursePage = response["pageNo"] as! Int
            if weakSelf?.coursePage == 1 {
                weakSelf?.courseArray.removeAll()
            }
            if response["list"] != nil, ((response["list"] as? [[String : Any]]) != nil) {
                weakSelf?.courseArray += Mapper<OrderModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.coursePage >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    @IBAction func allCourseClick(_ sender: UIButton) {
        sender.isSelected = true
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
            weakSelf?.getMyCourseByPage(pageNo: 1)
        }
        present(courseMenu, animated: true, completion: nil)
    }
    
    @IBAction func updateTimeClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        timeSort = sender.isSelected ? "desc" : "asc"
        allCourseBtn.isSelected = false
        getMyCourseByPage(pageNo: 1)
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseArray.count
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
        let cell: MyCourseCell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath) as! MyCourseCell
        let order = courseArray[indexPath.section]
        cell.courseImage.sd_setImage(with: URL(string: (order.photo != nil) ? order.photo! : ""), placeholderImage: UIImage(named: "default_image"))
        if order.courseHourId != nil {
            cell.courseName.text = order.lessonPeriod! + " " + order.classHourName!
        } else {
            cell.courseName.text = order.courseName
        }
        cell.courseCredit.text = "学分\(order.credit!)"
        for image in cell.starArray {
            if order.difficulty! > image.tag - 100 {
                image.image = UIImage(named: "star_select")
            } else {
                image.image = UIImage(named: "star_unselect")
            }
        }
        if order.tag == 0 {
            cell.typeImage.image = UIImage(named: "video_course")
        } else if order.tag == 1 {
            cell.typeImage.image = UIImage(named: "reservation_course")
        } else {
            cell.typeImage.image = UIImage(named: "study_group")
        }
        cell.updateTime.text = "更新时间 \(order.payTime!.components(separatedBy: ".").first!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.courseId = courseArray[indexPath.section].courseId!
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
