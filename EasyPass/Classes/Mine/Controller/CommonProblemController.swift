//
//  CommonProblemController.swift
//  EasyPass
//
//  Created by luan on 2017/7/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

class CommonProblemController: AntController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self
        AntManage.postRequest(path: "setting/findBrochureByType", params: ["type":"appHelp"], successResult: { (response) in
            if let str = response["data"] as? String {
                weakSelf?.webView.loadHTMLString("<div id=\"webview_content_wrapper\">\(str)</div>", baseURL: nil)
            }
        }, failureResult: {
            weakSelf?.navigationController?.popViewController(animated: true)
        })
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
