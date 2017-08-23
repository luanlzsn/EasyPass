//
//  BannerDetailController.swift
//  EasyPass
//
//  Created by luan on 2017/8/1.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class BannerDetailController: AntController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var bannerContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString("<div id=\"webview_content_wrapper\">\(bannerContent)</div>", baseURL: nil)
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
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
