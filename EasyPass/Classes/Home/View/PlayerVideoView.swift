//
//  PlayerVideoView.swift
//  EasyPass
//
//  Created by luan on 2017/8/3.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerVideoView: UIView {
    
    @IBOutlet weak var playBtn: UIButton!//播放按钮
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playerTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var progress: UIProgressView!//缓冲进度
    @IBOutlet weak var progressSlider: UISlider!//播放进度
    @IBOutlet weak var zoomBtn: UIButton!//缩放按钮
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    var timeObserver: Any?
    var timer: Timer?
    var videoUrl: String?//视频播放地址
    var courseId: Int?//课程ID
    var courseHourId: Int?//课时ID
    weak var oldView: UIView?
    weak var superController: UIViewController?
    let fullController = FullPlayerVideoController()
    var isLandscape = false//是否横屏
    var isFull = false
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(appwillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        progressSlider.setThumbImage(UIImage(named: "player_slider"), for: .normal)
        activityView.isHidden = true
    }
    
    func willDisappearController() {
        player?.pause()
        player?.currentItem?.cancelPendingSeeks()
        player?.currentItem?.asset.cancelLoading()
        if playerTime.text != "00:00" {
            player?.removeTimeObserver(timeObserver!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        activityView.center = center
    }
    
    // MARK: - 转屏通知
    func deviceOrientationDidChange() {
        if !Common.isVisibleWithController(viewController()!) {
            return
        }
        let orient = UIDevice.current.orientation
        weak var weakSelf = self
        if orient == .landscapeLeft || orient == .landscapeRight {
            if !isFull {
                isLandscape = true
                superController?.present(fullController, animated: false, completion: {
                    weakSelf?.backgroundColor = UIColor.red
                    weakSelf?.fullController.view.addSubview(weakSelf!)
                    weakSelf?.landscapeLayout()
                })
                isFull = true
            }
        } else if orient == .portrait || orient == .portraitUpsideDown {
            if !isFull {
                isLandscape = false
                fullController.dismiss(animated: false, completion: {
                    weakSelf?.oldView?.addSubview(weakSelf!)
                    weakSelf?.portraitLayout()
                })
                isFull = false
            }
        }
    }
    
    func landscapeLayout() {
        UIApplication.shared.isStatusBarHidden = true
        frame = UIScreen.main.bounds
        zoomBtn.isSelected = true
    }
    
    func portraitLayout() {
        UIApplication.shared.isStatusBarHidden = false
        frame = oldView!.bounds
        zoomBtn.isSelected = false
    }
    
    @IBAction func tapGestureClick() {
        if playBtn.isSelected {
            controlView.isHidden = !controlView.isHidden
            playBtn.isHidden = controlView.isHidden
            if controlView.isHidden {
                timer?.invalidate()
                timer = nil
            } else {
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hiddenControlView), userInfo: nil, repeats: false)
            }
        } else {
            playBtn.isHidden = false
        }
    }
    
    func hiddenControlView() {
        controlView.isHidden = true
        playBtn.isHidden = playBtn.isSelected
    }
    
    // MARK: - 播放课时视频
    func playerCourseHourVideo(_ courseHourVideoUrl: String) {
        if playerItem == nil {
            videoUrl = courseHourVideoUrl
            playerVideo()
        } else {
            player?.pause()
            playBtn.isHidden = false
            playBtn.isSelected = false
            controlView.isHidden = true
            
            if courseHourVideoUrl.isEmpty {
                AntManage.showDelayToast(message: "还没有视频")
                return
            }
            videoUrl = courseHourVideoUrl
            
            player?.currentItem?.cancelPendingSeeks()
            player?.currentItem?.asset.cancelLoading()
            if playerTime.text != "00:00" {
                player?.removeTimeObserver(timeObserver!)
            }
            
            playerItem?.removeObserver(self, forKeyPath: "status")
            playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            playerItem = nil
            
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            
            player = nil
            
            playerVideo()
        }
    }
    
    // MARK: - 播放
    @IBAction func playClick(_ sender: UIButton) {
        if playerItem == nil {
            playerVideo()
        } else {
            if playBtn.isSelected {
                player?.pause()
                playBtn.isHidden = false
                playBtn.isSelected = false
                controlView.isHidden = true
            } else {
                player?.play()
                playBtn.isHidden = true
                playBtn.isSelected = true
                controlView.isHidden = true
            }
        }
    }
    
    func playerVideo() {
        if videoUrl != nil, !(videoUrl?.isEmpty)! {
            playerItem = AVPlayerItem(url: URL(string: videoUrl!)!)
            playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            
            player = AVPlayer(playerItem: playerItem)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            layer.insertSublayer(playerLayer!, at: 0)
            player?.play()
            
            playBtn.isHidden = true
            playBtn.isSelected = true
            countVideoClick()
        } else {
            AntManage.showDelayToast(message: "还没有视频")
        }
    }
    
    // MARK: - 统计点击量
    func countVideoClick() {
        if courseHourId == nil {
            return
        }
        AntManage.postRequest(path: "course/countVideoClick", params: ["token":AntManage.userModel!.token!, "courseId":courseId!, "courseHourId":courseHourId!], successResult: { (_) in
            
        }, failureResult: {})
    }
    
    // MARK: - 开始拖动视频进度条
    @IBAction func beginProgressClick(_ sender: UISlider) {
        player?.pause()
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - 视频进度条拖动中
    @IBAction func progressClick(_ sender: UISlider) {
        let total = TimeInterval((playerItem?.duration.value)!) / TimeInterval((playerItem?.duration.timescale)!)
        let dragedSeconds = floorf(Float(total * Double(progressSlider.value)))
        let dragedCMTime = CMTimeMake(Int64(dragedSeconds), 1)
        player?.seek(to: dragedCMTime)
    }
    
    // MARK: - 结束拖动视频进度条
    @IBAction func endProgressClick(_ sender: UISlider) {
        player?.play()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hiddenControlView), userInfo: nil, repeats: false)
    }
    
    // MARK: - 缩放按钮点击事件
    @IBAction func zoomClick(_ sender: UIButton) {
//        if isFull {
//            UIDevice.setOrientation(.portrait)
//        } else {
//            UIDevice.setOrientation(.landscapeRight)
//        }
    }
    
    // MARK: - 视频播放完成
    func moviePlayDidEnd() {
        playBtn.isHidden = false
        playBtn.isSelected = false
        player?.pause()
        player?.seek(to: CMTimeMake(0, 1))
        progressSlider.value = 0
        playerTime.text = "00.00"
        player?.removeTimeObserver(timeObserver!)
    }
    
    // MARK: - 程序被挂起
    func appwillResignActive() {
        playBtn.isHidden = false
        playBtn.isSelected = false
        player?.pause()
    }
    
    // MARK: - 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem else { return }
        if keyPath == "status" {
            if item.status == AVPlayerItemStatus.readyToPlay {
                playBtn.isHidden = true
                playBtn.isSelected = true
                activityView.stopAnimating()
                activityView.isHidden = true
                monitoringPlayback()
                if Common.isVisibleWithController(viewController()!) {
                    player?.play()
                }
            } else {
                playBtn.isHidden = false
                playBtn.isSelected = false
                AntManage.showDelayToast(message: "视频加载失败，请重试！")
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = availableDuration()
            let duration = playerItem?.duration
            let totalDuration = CMTimeGetSeconds(duration!)
            progress.progress = Float(timeInterval / totalDuration)
        } else if keyPath == "playbackBufferEmpty" {
            activityView.startAnimating()
            activityView.isHidden = false
        } else if keyPath == "playbackLikelyToKeepUp" {
            activityView.stopAnimating()
            activityView.isHidden = true
            if playBtn.isSelected {
                player?.play()
            }
        }
    }
    
    // MARK: - 计算缓冲进度
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
        let timeRange = loadedTimeRanges?.first?.timeRangeValue//获取缓冲区域
        let startSeconds = CMTimeGetSeconds((timeRange?.start)!)
        let durationSeconds = CMTimeGetSeconds((timeRange?.duration)!)
        return startSeconds + durationSeconds
    }
    
    // MARK: - 监听播放状态
    func monitoringPlayback() {
        weak var weakSelf = self
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: { (time) in
            //当前进度
            weakSelf?.progressSlider.value = Float(CMTimeGetSeconds((weakSelf?.playerItem?.currentTime())!) / (TimeInterval((weakSelf?.playerItem?.duration.value)!) / TimeInterval((weakSelf?.playerItem?.duration.timescale)!)))
            //duration 总时长
            let durMin = Int((TimeInterval((weakSelf?.playerItem?.duration.value)!) / TimeInterval((weakSelf?.playerItem?.duration.timescale)!)) / 60)
            let durSec = Int(((TimeInterval((weakSelf?.playerItem?.duration.value)!) / TimeInterval((weakSelf?.playerItem?.duration.timescale)!))).truncatingRemainder(dividingBy: 60))
            weakSelf?.totalTime.text = NSString.init(format: "%02ld:%02ld", durMin, durSec) as String
            //当前时长进度progress
            let proMin = Int(CMTimeGetSeconds((weakSelf?.playerItem?.currentTime())!) / 60)
            let proSec = Int(CMTimeGetSeconds((weakSelf?.playerItem?.currentTime())!).truncatingRemainder(dividingBy: 60))
            weakSelf?.playerTime.text = NSString.init(format: "%02ld:%02ld", proMin, proSec) as String
        })
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
