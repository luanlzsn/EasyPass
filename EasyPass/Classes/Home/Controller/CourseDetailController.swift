//
//  CourseDetailController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class CourseDetailController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var playBtn: UIButton!//播放按钮
    @IBOutlet weak var infoBtn: UIButton!//简介按钮
    @IBOutlet weak var outlineBtn: UIButton!//大纲按钮
    @IBOutlet weak var lineLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionBtn: HomeMenuButton!//收藏
    @IBOutlet weak var customerServiceBtn: HomeMenuButton!//客服
    @IBOutlet weak var infoScrollView: UIScrollView!//简介内容视图
    @IBOutlet weak var outlineTableView: UITableView!
    @IBOutlet weak var courseName: UILabel!//课程名称
    @IBOutlet weak var credit: UILabel!//学分
    @IBOutlet var levelImageArray: [UIImageView]!//难度图片数组
    @IBOutlet weak var money: UILabel!//价格
    @IBOutlet weak var classHour: UILabel!//课时
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var detailLabel: UILabel!//详情
    @IBOutlet weak var suitableCrowd: UILabel!//适合人群
    @IBOutlet weak var learningGoal: UILabel!//学习目标
    @IBOutlet weak var commentNum: UILabel!//评论数
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!//评论输入框
    var isCourse = true
    var courseId = 0//课程id
    var courseModel: CourseModel?
    var commentArray = [CommentModel]()
    var classHourPageNo = 1//课时分页信息
    var classHourArray = [ClassHourModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isCourse {
            buyBtn.setTitle("预约", for: .normal)
            outlineBtn.isHidden = true
        }
        tableView.register(UINib(nibName: "CourseCommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseCommentCell")
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
        outlineTableView.estimatedRowHeight = 60.0
        outlineTableView.rowHeight = UITableViewAutomaticDimension
        weak var weakSelf = self
        outlineTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getCourseClassHourByPage(pageNo: 1)
        })
        outlineTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getCourseClassHourByPage(pageNo: weakSelf!.classHourPageNo + 1)
        })
        
        getCourseDetailById()
        getCommentByPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeight.constant = tableView.contentSize.height
    }
    
    // MARK: - 获取课程详情
    func getCourseDetailById() {
        weak var weakSelf = self
        AntManage.postRequest(path: "course/getCourseDetailById", params: ["token":AntManage.userModel!.token!, "courseId":courseId], successResult: { (response) in
            weakSelf?.courseModel = Mapper<CourseModel>().map(JSON: response)
            weakSelf?.refreshCourseInfo()
        }, failureResult: {
            AntManage.showDelayToast(message: "获取课程信息失败，请重试！")
            weakSelf?.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: - 获取课时列表
    func getCourseClassHourByPage(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "course/getCourseClassHourByPage", params: ["pageNo":pageNo, "pageSize":20, "courseId":courseId], successResult: { (response) in
            weakSelf?.classHourPageNo = response["pageNo"] as! Int
            if weakSelf?.classHourPageNo == 1 {
                weakSelf?.classHourArray.removeAll()
            }
            weakSelf?.classHourArray += Mapper<ClassHourModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.outlineTableView.mj_header.endRefreshing()
            weakSelf?.outlineTableView.mj_footer.endRefreshing()
            weakSelf?.outlineTableView.mj_footer.isHidden = weakSelf!.classHourPageNo >= (response["totalPage"] as! Int)
            weakSelf?.outlineTableView.reloadData()
        }, failureResult: {
            weakSelf?.outlineTableView.mj_header.endRefreshing()
            weakSelf?.outlineTableView.mj_footer.endRefreshing()
        })
    }
    
    // MARK: - 获取评论列表
    func getCommentByPage() {
        weak var weakSelf = self
        AntManage.postRequest(path: "comment/getCommentByPage", params: ["pageNo":1, "pageSize":3, "courseId":courseId, "timeSort":"desc"], successResult: { (response) in
            weakSelf?.commentArray = Mapper<CommentModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.commentNum.text = "\(response["total"] as! Int)"
            weakSelf?.tableView.reloadData()
        }, failureResult: {})
    }
    
    // MARK: - 刷新课程信息
    func refreshCourseInfo() {
        courseName.text = courseModel?.courseName
        credit.text = "学分\(courseModel!.credit!)"
        for star in levelImageArray {
            if courseModel!.difficulty! > star.tag - 100 {
                star.image = UIImage(named: "star_select")
            } else {
                star.image = UIImage(named: "star_unselect")
            }
        }
        money.text = "$\(courseModel!.price!)"
        detailLabel.text = courseModel?.courseDetail
        suitableCrowd.text = courseModel?.forCrowd
        learningGoal.text = courseModel?.studyGoal
        collectionBtn.isSelected = (courseModel?.collectFlag)!
    }
    
    // MARK: - 播放
    @IBAction func playClick(_ sender: UIButton) {
        
    }
    
    // MARK: - 简介
    @IBAction func infoClick(_ sender: UIButton) {
        sender.isSelected = true
        outlineBtn.isSelected = false
        lineLeft.constant = 0
        infoScrollView.isHidden = false
        outlineTableView.isHidden = true
    }
    
    // MARK: - 大纲
    @IBAction func outlineClick(_ sender: UIButton) {
        sender.isSelected = true
        infoBtn.isSelected = false
        lineLeft.constant = kScreenWidth / 2.0
        infoScrollView.isHidden = true
        outlineTableView.isHidden = false
        outlineTableView.reloadData()
        if classHourArray.count == 0 {
            getCourseClassHourByPage(pageNo: 1)
        }
    }

    // MARK: - 购买课程
    @IBAction func buyCourseClick(_ sender: UIButton) {
        performSegue(withIdentifier: "PaymentResults", sender: nil)
    }
    
    // MARK: - 更多评论
    @IBAction func moreCommectClick(_ sender: UIButton) {
        
    }
    
    // MARK: - 发布评论
    @IBAction func publishCommentClick(_ sender: UIButton) {
        kWindow?.endEditing(true)
        if commentTextView.text.isEmpty {
            AntManage.showDelayToast(message: "请输入评论内容！")
            return
        }
        weak var weakSelf = self
        AntManage.postRequest(path: "comment/addComment", params: ["token":AntManage.userModel!.token!, "courseId":courseId, "commentContent":commentTextView.text], successResult: { (response) in
            AntManage.showDelayToast(message: "发布评论成功！")
            weakSelf?.getCommentByPage()
            weakSelf?.commentTextView.text = "我的评论：xxx"
        }, failureResult: {})
    }
    
    // MARK: - 收藏
    @IBAction func collectionClick(_ sender: HomeMenuButton) {
        let path = sender.isSelected ? "collect/cancelCommentPraise" : "collect/addCourseCollect"
        AntManage.postRequest(path: path, params: ["token":AntManage.userModel!.token!, "courseId":courseId], successResult: { (response) in
            AntManage.showDelayToast(message: sender.isSelected ? "取消收藏成功！" : "收藏成功！")
            sender.isSelected = !sender.isSelected
        }, failureResult: {})
    }
    
    // MARK: - 分享
    @IBAction func shareClick(_ sender: HomeMenuButton) {
        
    }
    
    // MARK: - 客服
    @IBAction func customerServiceClick(_ sender: HomeMenuButton) {
        sender.isSelected = true
    }
    
    // MARK: - 加入购物车
    @IBAction func addShopCartClick(_ sender: UIButton) {
//        weak var weakSelf = self
        AntManage.postRequest(path: "shoppingcart/addOrUpdateShoppingCart", params: ["token":AntManage.userModel!.token!, "courseId":courseId, "price":courseModel!.price!, "quantity":1], successResult: { (_) in
            AntManage.showDelayToast(message: "加入购物车成功！")
        }, failureResult: {})
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerService" {
            let customerService = segue.destination as! CustomerServiceController
            customerService.customerServiceBtn = customerServiceBtn
        }
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return (tableView == outlineTableView) ? classHourArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == outlineTableView) ? 1 : commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (tableView == outlineTableView) ? 10 : 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == outlineTableView {
            let cell: CourseOutlineCell = tableView.dequeueReusableCell(withIdentifier: "CourseOutlineCell", for: indexPath) as! CourseOutlineCell
            let classHourModel = classHourArray[indexPath.section]
            cell.name.text = classHourModel.classHourName
            cell.info.text = classHourModel.content
            if classHourModel.price! > 0 {
                cell.money.text = "$ \(classHourModel.price!)"
                cell.money.isHidden = false
                cell.classHour.isHidden = false
                cell.watchBtn.backgroundColor = MainColor
                cell.watchBtn.setTitle("购买", for: .normal)
            } else {
                cell.money.isHidden = true
                cell.classHour.isHidden = true
                cell.watchBtn.backgroundColor = Common.colorWithHexString(colorStr: "f9bd53")
                cell.watchBtn.setTitle("观看", for: .normal)
            }
            return cell
        } else {
            let cell: CourseCommentCell = tableView.dequeueReusableCell(withIdentifier: "CourseCommentCell", for: indexPath) as! CourseCommentCell
            let comment = commentArray[indexPath.row]
            cell.headPortrait.sd_setImage(with: URL(string: comment.headImg!))
            cell.nickName.text = comment.nickName
            cell.commont.text = comment.content
            cell.time.text = comment.createTime?.components(separatedBy: " ").first
            return cell
        }
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
