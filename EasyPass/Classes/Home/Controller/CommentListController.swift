//
//  CommentListController.swift
//  EasyPass
//
//  Created by luan on 2017/7/19.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentListController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var courseId = 0//课程id
    var commentArray = [CommentModel]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CourseCommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseCommentCell")
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.getCommentByPage(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.getCommentByPage(pageNo: weakSelf!.pageNo + 1)
        })
        getCommentByPage(pageNo: 1)
    }
    
    // MARK: - 获取评论列表
    func getCommentByPage(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "comment/getCommentByPage", params: ["pageNo":pageNo, "pageSize":20, "courseId":courseId, "timeSort":"desc"], successResult: { (response) in
            weakSelf?.pageNo = response["pageNo"] as! Int
            if weakSelf?.pageNo == 1 {
                weakSelf?.commentArray.removeAll()
            }
            if response["list"] != nil, ((response["list"] as? [[String : Any]]) != nil) {
                weakSelf?.commentArray += Mapper<CommentModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = weakSelf!.pageNo >= (response["totalPage"] as! Int)
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CourseCommentCell = tableView.dequeueReusableCell(withIdentifier: "CourseCommentCell", for: indexPath) as! CourseCommentCell
        let comment = commentArray[indexPath.row]
        if comment.headImg != nil {
            cell.headPortrait.sd_setImage(with: URL(string: comment.headImg!), placeholderImage: UIImage(named: "default_image"))
        } else {
            cell.headPortrait.image = UIImage(named: "default_image")
        }
        cell.nickName.text = comment.nickName?.removingPercentEncoding
        cell.commont.text = comment.content
        cell.time.text = comment.createTime?.components(separatedBy: " ").first
        return cell
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
