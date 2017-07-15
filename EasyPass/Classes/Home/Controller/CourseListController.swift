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
    var classifyModel: ClassifyModel!
    var courseArray = [CourseModel]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = classifyModel.name
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
        
    }
    
    func getCourseByPage(pageNo: Int) {
        weak var weakSelf = self
        let params = ["pageNo":pageNo, "pageSize":20, "classifyId":classifyModel.id!]
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
        if sender.tag == 10 {
            performSegue(withIdentifier: "CourseMenu", sender: nil)
        }
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseMenu" {
            let courseMenu = segue.destination as! CourseMenuController
            courseMenu.selectType = navigationItem.title!
        } else if segue.identifier == "CourseDetail" {
            let courseDetail = segue.destination as! CourseDetailController
            let courseModel = sender as! CourseModel
            courseDetail.navigationItem.title = courseModel.courseName
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
        cell.courseImage.sd_setImage(with: URL(string: model.photo!))
        cell.courseName.text = model.courseName
        cell.courseCredit.text = "学分\(model.credit!)"
        cell.teacher.text = model.teacher! + model.teacherDesc!
        cell.money.text = "$" + "\(model.price!)"
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
