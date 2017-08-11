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
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "",
                                          images : UIImage(named: "share_icon"),
                                          url : NSURL(string:"http://mob.com") as URL!,
                                          title : "Epass",
                                          type : SSDKContentType.auto)
        SSUIShareActionSheetStyle.setShareActionSheetStyle(.simple)
        ShareSDK.showShareActionSheet(view, items: [SSDKPlatformType.subTypeWechatSession.rawValue,SSDKPlatformType.subTypeWechatTimeline.rawValue], shareParams: shareParames) { (state, _, nil, entity, error, _) in
            print("授权失败,错误描述:\(String(describing: error))")
            switch state {
            case SSDKResponseState.success: AntManage.showDelayToast(message: "分享成功")
            case SSDKResponseState.fail:    AntManage.showDelayToast(message: "授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  AntManage.showDelayToast(message: "取消分享")
            default:
                break
            }
        }
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
