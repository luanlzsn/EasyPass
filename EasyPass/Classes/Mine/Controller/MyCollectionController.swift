//
//  MyCollectionController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MyCollectionController: AntController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var allCourseBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var collectArray = [CourseModel]()
    var collectPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getCourseCollectByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getCourseCollectByPage(pageNo: weakSelf!.collectPage + 1)
        })
        getCourseCollectByPage(pageNo: 1)
    }
    
    func searchClick() {
        
    }
    
    func getCourseCollectByPage(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "collect/getCourseCollectByPage", params: ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20], successResult: { (response) in
            weakSelf?.collectPage = response["pageNo"] as! Int
            if weakSelf?.collectPage == 1 {
                weakSelf?.collectArray.removeAll()
            }
            weakSelf?.collectArray += Mapper<CourseModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.collectPage >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    @IBAction func allCourseClick(_ sender: UIButton) {
        sender.isSelected = true
        timeBtn.isSelected = false
        tableView.reloadData()
    }
    
    @IBAction func updateTimeClick(_ sender: UIButton) {
        sender.isSelected = true
        allCourseBtn.isSelected = false
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return collectArray.count
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
        let cell: MyCollectionCell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionCell", for: indexPath) as! MyCollectionCell
        let courseModel = collectArray[indexPath.row]
        cell.courseImage.sd_setImage(with: URL(string: courseModel.photo!), placeholderImage: UIImage(named: "default_image"))
        cell.courseName.text = courseModel.courseName
        cell.courseCredit.text = "学分\(courseModel.credit!)"
        cell.money.text = "$" + "\(courseModel.price!)"
        cell.classHour.text = "/\(courseModel.classHour!)课时"
        for image in cell.starArray {
            if courseModel.difficulty! > image.tag - 100 {
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
        courseDetail.courseId = collectArray[indexPath.row].id!
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
