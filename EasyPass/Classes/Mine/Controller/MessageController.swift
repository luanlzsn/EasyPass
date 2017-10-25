//
//  MessageController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MessageController: AntController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var messageArray = [MessageModel]()
    var messagePageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf?.findMessageList(pageNo: 1)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf?.findMessageList(pageNo: weakSelf!.messagePageNo + 1)
        })
        findMessageList(pageNo: 1)
    }
    
    func findMessageList(pageNo: Int) {
        weak var weakSelf = self
        AntManage.postRequest(path: "message/findMessageList", params: ["token":AntManage.userModel!.token!, "pageNo":pageNo, "pageSize":20], successResult: { (response) in
            weakSelf?.messagePageNo = response["pageNo"] as! Int
            if weakSelf?.messagePageNo == 1 {
                weakSelf?.messageArray.removeAll()
            }
            if let list = response["list"] as? [[String : Any]] {
                 weakSelf?.messageArray += Mapper<MessageModel>().mapArray(JSONArray: list)
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.tableView.mj_footer.isHidden = (weakSelf!.messagePageNo >= (response["totalPage"] as! Int))
            weakSelf?.tableView.reloadData()
        }, failureResult: {
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        })
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.accessoryView = UIImageView(image: UIImage(named: "message_arrow"))
        let model = messageArray[indexPath.row]
        cell.title.text = model.msgHeader
        let attr = try! NSMutableAttributedString(data: (model.msgDetail ?? "").data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        attr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attr.length))
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgb: 0x939598), range: NSMakeRange(0, attr.length))
        cell.content.attributedText = attr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "BannerDetail") as! BannerDetailController
        let model = messageArray[indexPath.row]
        detail.navigationItem.title = model.msgHeader
        detail.bannerContent = model.msgDetail!
        navigationController?.pushViewController(detail, animated: true)
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
