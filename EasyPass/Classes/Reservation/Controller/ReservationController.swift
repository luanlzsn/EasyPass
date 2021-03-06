//
//  ReservationController.swift
//  EasyPass
//
//  Created by luan on 2017/6/27.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class ReservationController: AntController,UITableViewDelegate,UITableViewDataSource,Reservation_Delegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortBtnArray: [UIButton]!
    var classifyModel: ClassifyModel?//选择的专业
    var grade = 0//年级
    var hotSort = ""//hot排序
    var timeSort = ""//时间排序
    var priceSort = ""//价格排序
    var courseName = ""//课程名称
    var reservationArray = [CourseModel]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        getReservationByPage(pageNo: pageNo)
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf?.getReservationByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.getReservationByPage(pageNo: weakSelf!.pageNo + 1)
        })
    }
    
    func searchClick() {
        let alert = UIAlertController(title: "提示", message: "输入搜索内容", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "请输入搜索内容"
        }
        weak var weakSelf = self
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let textField = alert.textFields?.first
            weakSelf?.courseName = textField!.text!
            weakSelf?.getReservationByPage(pageNo: 1)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getReservationByPage(pageNo: Int) {
        weak var weakSelf = self
        var params = ["pageNo":pageNo, "pageSize":20, "tag":1, "courseName":courseName] as [String : Any]
        if classifyModel != nil {
            params["classifyId"] = classifyModel!.id!
        }
        if grade != 0 {
            params["grade"] = grade
        }
        if !hotSort.isEmpty {
            params["hot"] = hotSort
        }
        if !timeSort.isEmpty {
            params["timeSort"] = timeSort
        }
        if !priceSort.isEmpty {
            params["priceSort"] = priceSort
        }
        AntManage.postRequest(path: "course/getCourseByPage", params: params, successResult: { (response) in
            weakSelf?.pageNo = response["pageNo"] as! Int
            if weakSelf?.pageNo == 1 {
                weakSelf?.reservationArray.removeAll()
            }
            if let list = response["list"] as? [[String : Any]] {
                weakSelf?.reservationArray += Mapper<CourseModel>().mapArray(JSONArray: list)
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.pageNo >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }

    @IBAction func sortClick(_ sender: UIButton) {
        for btn in sortBtnArray {
            if sender == btn {
                btn.isSelected = !sender.isSelected
            } else {
                btn.isSelected = false
            }
        }
        if sender == sortBtnArray[0] {
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
                weakSelf?.getReservationByPage(pageNo: 1)
            }
            present(courseMenu, animated: true, completion: nil)
        } else if sender == sortBtnArray[1] {
            hotSort = sender.isSelected ? "asc" : "desc"
            priceSort = ""
            timeSort = ""
            getReservationByPage(pageNo: 1)
        } else if sender == sortBtnArray[2] {
            timeSort = sender.isSelected ? "asc" : "desc"
            priceSort = ""
            hotSort = ""
            getReservationByPage(pageNo: 1)
        } else if sender == sortBtnArray[3] {
            priceSort = sender.isSelected ? "asc" : "desc"
            timeSort = ""
            hotSort = ""
            getReservationByPage(pageNo: 1)
        }
    }
    
    // MARK: - Reservation_Delegate
    func reservationCourse(row: Int) {
        if Common.checkIsOperation(controller: self) {
            let model = reservationArray[row]
            AntManage.postRequest(path: "shoppingcart/addOrUpdateShoppingCart", params: ["token":AntManage.userModel!.token!, "courseId":model.id!, "number":1, "add":true], successResult: { (_) in
                AntManage.showDelayToast(message: "加入购物车成功！")
                NotificationCenter.default.post(name: NSNotification.Name(kAddShopCartSuccess), object: nil)
            }, failureResult: {})
        }
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReservationCell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as! ReservationCell
        cell.delegate = self
        cell.tag = indexPath.row
        let model = reservationArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: model.photo ?? ""), placeholderImage: UIImage(named: "default_image"))
        cell.courseName.text = model.courseName
        cell.courseCredit.text = "学分\(model.credit ?? 0)"
        cell.teacher.text = model.teacher!
        if model.tag == 0 {
            cell.typeImage.image = UIImage(named: "video_course")
            cell.money.text = "$" + "\(model.priceIos ?? 0.0)"
        } else if model.tag == 1 {
            cell.typeImage.image = UIImage(named: "reservation_course")
            cell.money.text = "$" + "\(model.price ?? 0.0)"
        } else {
            cell.typeImage.image = UIImage(named: "study_group")
            cell.money.text = "$" + "\(model.price ?? 0.0)"
        }
        for image in cell.starArray {
            if model.difficulty! > image.tag - 100 {
                image.image = UIImage(named: "star_select")
            } else {
                image.image = UIImage(named: "star_unselect")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let courseDetail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseDetail") as! CourseDetailController
        courseDetail.courseId = reservationArray[indexPath.row].id!
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
