//
//  CourseDetailController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var commontNum: UILabel!//评论数
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var commontTextView: UITextView!//评论输入框
    var isCourse = true
    var commontArray = ["非常好的一款软件，老师讲的也非常好！","非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！","非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！非常好的一款软件，老师讲的也非常好！"]
    var outlineArray = ["平面向量","平面向量平面向量","平面向量平面向量平面向量","平面向量平面向量平面向量平面向量","平面向量平面向量平面向量平面向量平面向量"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "大学一年级Mathematics Level One"
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeight.constant = tableView.contentSize.height
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
    }

    // MARK: - 购买课程
    @IBAction func buyCourseClick(_ sender: UIButton) {
        
    }
    
    // MARK: - 发布评论
    @IBAction func publishCommontClick(_ sender: UIButton) {
        
    }
    
    // MARK: - 收藏
    @IBAction func collectionClick(_ sender: HomeMenuButton) {
        sender.isSelected = !sender.isSelected
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
        return (tableView == outlineTableView) ? outlineArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == outlineTableView) ? 1 : commontArray.count
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
            cell.info.text = outlineArray[indexPath.section]
            if indexPath.section > 1 {
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
            cell.commont.text = commontArray[indexPath.row]
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
