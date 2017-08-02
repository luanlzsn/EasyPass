//
//  CourseSearchController.swift
//  EasyPass
//
//  Created by luan on 2017/7/5.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CourseSearchController: AntController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CourseSearch_Delegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotCollection: UICollectionView!
    @IBOutlet weak var historyCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let hotArray = ["Java","计算机","化学","新闻"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hotCollection.register(UINib(nibName: "CourseSearchCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseSearchCollectionViewCell")
        historyCollection.register(UINib(nibName: "CourseSearchCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseSearchCollectionViewCell")
    }
    
    // MARK: - 清除历史
    @IBAction func clearHistoryClick(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "SearchHistory")
        UserDefaults.standard.synchronize()
        historyCollection.reloadData()
        tableView.reloadData()
    }
    
    // MARK: - CourseSearch_Delegate
    func deleteSearch(row: Int) {
        var historyArray = UserDefaults.standard.object(forKey: "SearchHistory") as! [String]
        historyArray.remove(at: row)
        if historyArray.count == 0 {
            UserDefaults.standard.set(nil, forKey: "SearchHistory")
        } else {
            UserDefaults.standard.set(historyArray, forKey: "SearchHistory")
        }
        UserDefaults.standard.synchronize()
        historyCollection.reloadData()
        tableView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 40 - 30) / 4.0, height: 35)
    }
    
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hotCollection {
            return hotArray.count
        } else {
            if let historyArray = UserDefaults.standard.object(forKey: "SearchHistory") as? [String] {
                return historyArray.count
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseSearchCollectionViewCell", for: indexPath) as! CourseSearchCollectionViewCell
        if collectionView == hotCollection {
            cell.searchContent.text = hotArray[indexPath.row]
        } else {
            cell.searchContent.text = (UserDefaults.standard.object(forKey: "SearchHistory") as! [String])[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let historyArray = UserDefaults.standard.object(forKey: "SearchHistory") as? [String] {
            return historyArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseSearchTableViewCell", for: indexPath) as! CourseSearchTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.searchContent.text = (UserDefaults.standard.object(forKey: "SearchHistory") as! [String])[indexPath.row]
        return cell
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        var historyArray = [String]()
        if let array = UserDefaults.standard.object(forKey: "SearchHistory") as? [String] {
            historyArray += array
        }
        if historyArray.contains(searchBar.text!) {
            historyArray.remove(at: historyArray.index(of: searchBar.text!)!)
        }
        if historyArray.count == 8 {
            historyArray.removeLast()
        }
        historyArray.insert(searchBar.text!, at: 0)
        UserDefaults.standard.set(historyArray, forKey: "SearchHistory")
        UserDefaults.standard.synchronize()
        historyCollection.reloadData()
        tableView.reloadData()
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
