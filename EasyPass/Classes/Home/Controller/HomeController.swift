//
//  HomeController.swift
//  EasyPass
//
//  Created by luan on 2017/6/25.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeController: AntController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CycleScrollView_Delegate {

    @IBOutlet weak var collection: UICollectionView!
    var bannerArray = [BannerModel]()
    var famousAphorism = ""//名言警句
    var selectClassify: ClassifyModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findBannerList()
        getFamousAphorism()
        findClassifyList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        if !AntManage.isLogin {
            present(UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()!, animated: true, completion: nil)
        } else {
            collection.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK: - 获取banner信息
    func findBannerList() {
        weak var weakSelf = self
        AntManage.postRequest(path: "advertise/findBannerList", params: nil, successResult: { (response) in
            weakSelf?.bannerArray = Mapper<BannerModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.collection.reloadData()
        }, failureResult: {})
    }
    
    // MARK: - 名言警句
    func getFamousAphorism() {
        weak var weakSelf = self
        AntManage.postRequest(path: "setting/findBrochureByType", params: ["type":"tags"], successResult: { (response) in
            weakSelf?.famousAphorism = response["data"] as! String
            weakSelf?.collection.reloadData()
        }, failureResult: {})
    }
    
    // MARK: - 获取专业分类
    func findClassifyList() {
        weak var weakSelf = self
        AntManage.postRequest(path: "course/findClassifyList", params: nil, successResult: { (response) in
            AntManage.classifyList = Mapper<ClassifyModel>().mapArray(JSONArray: response["list"] as! [[String : Any]])
            weakSelf?.collection.reloadData()
        }, failureResult: {})
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            var height = #imageLiteral(resourceName: "home_bg").size.height + 60 + 40 + 15 + 50
            height += (kScreenWidth - 30) / 23.0 * 10.0
            return CGSize(width: kScreenWidth, height: height)
        } else {
            let width = (kScreenWidth - 30 - 10) / 2.0
            return CGSize(width: width, height: width / 165.0 * 100.0)
        }
    }
    
    // MARK: - 跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseList" {
            let courseList = segue.destination as! CourseListController
            let model = sender as! ClassifyModel
            courseList.classifyModel = model
        }
    }
    
    // MARK: - CycleScrollView_Delegate
    func didSelectBanner(index: Int) {
        
    }
    
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : AntManage.classifyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: HomeHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCell", for: indexPath) as! HomeHeaderCell
            if AntManage.isLogin {
                cell.headImage.sd_setImage(with: URL(string: AntManage.userModel!.headImg!), for: .normal, placeholderImage: UIImage(named: "head_defaults"))
            } else {
                cell.headImage.setImage(UIImage(named: "head_defaults"), for: .normal)
            }
            cell.nickName.text = AntManage.userModel?.nickName
            cell.bannerView.delegate = self
            var imgArray = [String]()
            for model in self.bannerArray {
                imgArray.append(model.img!)
            }
            cell.bannerView.setBannerWithUrlArry(urlArry: imgArray)
            cell.famousAphorism.text = famousAphorism
            return cell
        } else {
            let cell: HomeCourseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCourseCell", for: indexPath) as! HomeCourseCell
            let model = AntManage.classifyList[indexPath.row]
            cell.imgView.sd_setImage(with: URL(string: model.img!), placeholderImage: UIImage(named: "default_image"))
            cell.courseTitle.text = model.name
            cell.selectImage.isHidden = (selectClassify != model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectClassify = AntManage.classifyList[indexPath.row]
        collectionView.reloadData()
        performSegue(withIdentifier: "CourseList", sender: selectClassify)
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
