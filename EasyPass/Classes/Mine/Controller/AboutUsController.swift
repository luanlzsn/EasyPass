//
//  AboutUsController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class AboutUsController: AntController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share_select")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(shareClick))
        
//        weak var weakSelf = self
//        AntManage.postRequest(path: "setting/findBrochureByType", params: ["type":"aboutUs"], successResult: { (response) in
//            weakSelf?.webView.loadHTMLString("<div id=\"webview_content_wrapper\">\(response["data"] as! String)</div>", baseURL: nil)
//        }, failureResult: {
//            weakSelf?.navigationController?.popViewController(animated: true)
//        })
    }
    
    func shareClick() {
        
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let jsStr = "function imgAutoFit() {var imgs = document.getElementsByTagName('img');for (var i = 0; i < imgs.length; ++i) {var img = imgs[i];img.style.maxWidth = \((kScreenWidth - 10));}}"
        webView.stringByEvaluatingJavaScript(from: jsStr)
        webView.stringByEvaluatingJavaScript(from: "imgAutoFit()")
        
        //获取内容实际高度（像素）
        let height = ("document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))" as NSString).floatValue
        webView.scrollView.isScrollEnabled = CGFloat(height) > kScreenHeight - 64
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
