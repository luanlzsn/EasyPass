//
//  CycleScrollView.swift
//  MoFan
//
//  Created by luan on 2017/2/7.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit

@objc protocol CycleScrollView_Delegate {
    func didSelectBanner(index: Int)
}

class CycleScrollView: UIView,UIScrollViewDelegate {
    
    var totalPage = 0//图片总张数
    var curPage = 0//当前滚的是第几张
    var bannerWidth : CGFloat = kScreenWidth//宽度
    var bannerHeight : CGFloat = 0//高度
    var scrollTimer : Timer?
    var scrollView = UIScrollView()
    var imagesArray = [String]()
    var curImages = [String]()
    var pageControl = UIPageControl()
    weak var delegate : CycleScrollView_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerHeight = height
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: kScreenWidth * 3.0, height: 0)
        addSubview(scrollView)
        
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = MainColor
        addSubview(pageControl)
        
        refreshScrollView()
    }
    
    //MARK: - 设置banner数据
    func setBannerWithUrlArry(urlArry: [String], bannerWidth: CGFloat, bannerHeight: CGFloat) {
        totalPage = urlArry.count
        self.bannerWidth = bannerWidth
        self.bannerHeight = bannerHeight
        curPage = 1
        imagesArray = urlArry
        pageControl.numberOfPages = totalPage
        pageControl.currentPage = curPage - 1
        refreshScrollView()
        if totalPage > 1 {
            starTimer()
            scrollView.isScrollEnabled = true
        } else {
            stopTimer()
            scrollView.isScrollEnabled = false
        }
    }
    
    //MARK: - 点击banner
    func handleTap() {
        delegate?.didSelectBanner(index: curPage - 1)
    }
    
    func refreshScrollView() {
        if imagesArray.isEmpty {
            return
        }
        let views = scrollView.subviews
        for subView in views {
            subView.removeFromSuperview()
        }
        getDisplayImagesWithCurpage(page: curPage)
        
        for i in 0..<3 {
            let imageView = UIImageView(frame: CGRect(x: kScreenWidth * CGFloat(i) + (kScreenWidth - bannerWidth) / 2.0, y: (height - bannerHeight) / 2.0, width: bannerWidth, height: bannerHeight))
            imageView.isUserInteractionEnabled = true
            imageView.sd_setImage(with: URL(string: curImages[i]), placeholderImage: UIImage(named: "not_loaded"))
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            imageView.addGestureRecognizer(singleTap)
            scrollView.addSubview(imageView)
        }
        scrollView.setContentOffset(CGPoint(x: kScreenWidth, y: 0), animated: false)
    }
    
    func getDisplayImagesWithCurpage(page: Int) {
        let pre = validPageValue(value: curPage - 1)
        let last = validPageValue(value: curPage + 1)
        if !curImages.isEmpty {
            curImages.removeAll()
        }
        curImages.append(imagesArray[pre - 1])
        curImages.append(imagesArray[curPage - 1])
        curImages.append(imagesArray[last - 1])
    }
    
    func validPageValue(value: Int) -> Int {
        var pageValue = value
        if value == 0 {
            pageValue = totalPage
        }
        if value == totalPage + 1 {
            pageValue = 1
        }
        return pageValue
    }
    
    //MARK: - 停止计时器
    func stopTimer() {
        if scrollTimer != nil {
            scrollTimer?.invalidate()
            scrollTimer = nil
        }
    }
    
    //MARK: - 启动计时器
    func starTimer() {
        if scrollTimer == nil {
            createTimer()
        }
    }
    
    //MARK: - 创建计时器
    func createTimer() {
        weak var weakSelf = self
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 2, block: { (_) in
            weakSelf?.scrollView.setContentOffset(CGPoint(x: kScreenWidth * 2, y: 0), animated: true)
        }, repeats: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= kScreenWidth * 2 {
            curPage = validPageValue(value: curPage + 1)
            refreshScrollView()
        }
        if scrollView.contentOffset.x <= 0 {
            curPage = validPageValue(value: curPage - 1)
            refreshScrollView()
        }
        pageControl.currentPage = curPage - 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滑动图片时停止计时器
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //手动滑动结束后开启计时器
        starTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        pageControl.frame = CGRect(x: 0, y: height - 30, width: kScreenWidth, height: 30)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
