//
//  CourseMenuController.swift
//  EasyPass
//
//  Created by luan on 2017/7/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CourseMenuController: AntController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var gradeTableView: UITableView!
    var gradeArray = ["大学一年级","大学二年级","大学三年级","大学四年级"]
    var selectClassify: ClassifyModel!
    var selectGrade = 0
    var changeSelect: ConfirmBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeTableView.separatorInset = UIEdgeInsets.zero
        typeTableView.layoutMargins = UIEdgeInsets.zero
    }

    @IBAction func dismissClick(_ sender: UITapGestureRecognizer) {
        if changeSelect != nil {
            changeSelect!(["Classify":selectClassify, "Grade":selectGrade])
            changeSelect = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.className() == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == typeTableView ? AntManage.classifyList.count : gradeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == typeTableView {
            let cell: CourseTypeCell = tableView.dequeueReusableCell(withIdentifier: "CourseTypeCell", for: indexPath) as! CourseTypeCell
            let classify = AntManage.classifyList[indexPath.row]
            cell.courseType.text = classify.name
            cell.courseType.textColor = (classify == selectClassify) ? MainColor : Common.colorWithHexString(colorStr: "969696")
            cell.arrowImage.isHidden = classify != selectClassify
            return cell
        } else {
            let cell: CourseGradeCell = tableView.dequeueReusableCell(withIdentifier: "CourseGradeCell", for: indexPath) as! CourseGradeCell
            cell.courseGrade.text = gradeArray[indexPath.row]
            cell.courseGrade.textColor = (indexPath.row + 1 == selectGrade) ? UIColor.white : Common.colorWithHexString(colorStr: "969696")
            cell.courseGrade.backgroundColor = (indexPath.row + 1 == selectGrade) ? MainColor : UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == typeTableView {
            selectClassify = AntManage.classifyList[indexPath.row]
            tableView.reloadData()
        } else {
            selectGrade = indexPath.row + 1
            tableView.reloadData()
            if changeSelect != nil {
                changeSelect!(["Classify":selectClassify, "Grade":selectGrade])
                changeSelect = nil
            }
            dismiss(animated: true, completion: nil)
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
