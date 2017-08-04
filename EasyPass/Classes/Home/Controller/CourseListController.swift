//
//  CourseListController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class CourseListController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var menuBtnArray: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    var classifyModel: ClassifyModel?//选择的专业
    var grade = 0//年级
    var term = -1//学期
    var timeSort = ""//时间排序
    var priceSort = ""//价格排序
    var courseName = ""//课程名称
    var courseArray = [CourseModel]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        getCourseByPage(pageNo: pageNo)
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getCourseByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getCourseByPage(pageNo: weakSelf!.pageNo + 1)
        })
    }
    
    func searchClick() {
        let courseSearch = UIStoryboard(name: "Mine", bundle: Bundle.main).instantiateViewController(withIdentifier: "CourseSearch") as! CourseSearchController
        weak var weakSelf = self
        courseSearch.checkSearchCourse = { (searchStr) -> () in
            weakSelf?.courseName = searchStr as! String
            weakSelf?.getCourseByPage(pageNo: 1)
        }
        navigationController?.pushViewController(courseSearch, animated: true)
    }
    
    func getCourseByPage(pageNo: Int) {
        weak var weakSelf = self
        var params = ["pageNo":pageNo, "pageSize":20, "courseName":courseName] as [String : Any]
        if classifyModel != nil {
            params["classifyId"] = classifyModel!.id!
        }
        if grade != 0 {
            params["grade"] = grade
        }
        if term != -1 {
            params["term"] = term
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
                weakSelf?.courseArray.removeAll()
            }
            weakSelf?.courseArray += Mapper<CourseModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.pageNo >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }

    @IBAction func menuClick(_ sender: UIButton) {
        for btn in menuBtnArray {
            btn.isSelected = sender == btn
        }
        if sender == menuBtnArray[0] {
            performSegue(withIdentifier: "CourseMenu", sender: nil)
        } else if sender == menuBtnArray[1] {
            let actionSheet = UIAlertController(title: "选择学期", message: nil, preferredStyle: .actionSheet)
            weak var weakSelf = self
            actionSheet.addAction(UIAlertAction(title: "Summer", style: .default, handler: { (_) in
                weakSelf?.term = 0
                weakSelf?.getCourseByPage(pageNo: 1)
            }))
            actionSheet.addAction(UIAlertAction(title: "Fall", style: .default, handler: { (_) in
                weakSelf?.term = 1
                weakSelf?.getCourseByPage(pageNo: 1)
            }))
            actionSheet.addAction(UIAlertAction(title: "Winter", style: .default, handler: { (_) in
                weakSelf?.term = 2
                weakSelf?.getCourseByPage(pageNo: 1)
            }))
            actionSheet.addAction(UIAlertAction(title: "All", style: .default, handler: { (_) in
                weakSelf?.term = -1
                weakSelf?.getCourseByPage(pageNo: 1)
            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        } else if sender == menuBtnArray[2] {
            timeSort = sender.isSelected ? "asc" : "desc"
            priceSort = ""
            getCourseByPage(pageNo: 1)
        } else if sender == menuBtnArray[3] {
            priceSort = sender.isSelected ? "asc" : "desc"
            timeSort = ""
            getCourseByPage(pageNo: 1)
        }
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseMenu" {
            let courseMenu = segue.destination as! CourseMenuController
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
                weakSelf?.getCourseByPage(pageNo: 1)
            }
        } else if segue.identifier == "CourseDetail" {
            let courseDetail = segue.destination as! CourseDetailController
            let courseModel = sender as! CourseModel
            courseDetail.courseId = courseModel.id!
        }
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
        let cell: CourseCell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        let model = courseArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: model.photo!), placeholderImage: UIImage(named: "default_image"))
        cell.courseName.text = model.courseName
        cell.courseCredit.text = "学分\(model.credit!)"
        cell.money.text = "$" + ((model.price != nil) ? "\(model.price!)" : "0.0")
        cell.classHour.text = "/\(model.classHour!)课时"
        if model.tag == 0 {
            cell.typeImage.image = UIImage(named: "video_course")
        } else if model.tag == 1 {
            cell.typeImage.image = UIImage(named: "reservation_course")
        } else {
            cell.typeImage.image = UIImage(named: "study_group")
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
        performSegue(withIdentifier: "CourseDetail", sender: courseArray[indexPath.row])
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
