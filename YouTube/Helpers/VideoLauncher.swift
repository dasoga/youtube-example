//
//  VideoLauncher.swift
//  YouTube
//
//  Created by Dante Solorio on 8/19/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .System)
        let image = UIImage(named: "pauseButton")
        button.setImage(image, forState: .Normal)
        button.tintColor = .whiteColor()
        button.hidden = true
        button.addTarget(self, action: #selector(handlePause), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let videoTotalLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(13)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var videoSlider:UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .redColor()
        slider.maximumTrackTintColor = .whiteColor()
        slider.setThumbImage(UIImage(named: "thumb"), forState: .Normal)
        slider.addTarget(self, action: #selector(handleSliderChange), forControlEvents: .ValueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var player: AVPlayer?
    var isPlaying = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        pausePlayButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        pausePlayButton.widthAnchor.constraintEqualToConstant(50).active = true
        pausePlayButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        controlsContainerView.addSubview(videoTotalLengthLabel)
        videoTotalLengthLabel.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -8).active = true
        videoTotalLengthLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        videoTotalLengthLabel.widthAnchor.constraintEqualToConstant(50).active = true
        videoTotalLengthLabel.heightAnchor.constraintEqualToConstant(24).active = true
        
        controlsContainerView.addSubview(videoCurrentTimeLabel)
        videoCurrentTimeLabel.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
        videoCurrentTimeLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        videoCurrentTimeLabel.widthAnchor.constraintEqualToConstant(50).active = true
        videoCurrentTimeLabel.heightAnchor.constraintEqualToConstant(24).active = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraintEqualToAnchor(videoCurrentTimeLabel.rightAnchor).active = true
        videoSlider.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        videoSlider.rightAnchor.constraintEqualToAnchor(videoTotalLengthLabel.leftAnchor).active = true
        videoSlider.heightAnchor.constraintEqualToConstant(30).active = true
        
        backgroundColor = .blackColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPlayerView(){
        let urlString = "https://firebasestorage.googleapis.com/v0/b/chatrealtime-1e87d.appspot.com/o/message_movies%2F1EEC633D-F705-498C-8971-17C984A62FB7.mov?alt=media&token=fecdf347-0790-4f67-b4ee-7d84fce4a6d2"
        if let url = NSURL(string: urlString){
            player = AVPlayer(URL: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .New, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue(), usingBlock: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds % 60))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.videoCurrentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                // lets move slider
                if let duration = self.player?.currentItem?.duration{
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
                
            })
            
        }
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clearColor(), UIColor.blackColor().CGColor]
        gradientLayer.locations = [0.7, 1.2]
            
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicator.stopAnimating()
            controlsContainerView.backgroundColor = .clearColor()
            pausePlayButton.hidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoTotalLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    // MARK: - Handle functions
    func handlePause(){
        if isPlaying{
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        }else{
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
        }
        
        isPlaying = !isPlaying
    }
    
    func handleSliderChange(){
//        print(videoSlider.value)
        if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seekToTime(seekTime, completionHandler: { (completedSeek) in
                // Do something later here
            })
            
        }
    }
    
    
}

class VideoLauncher: NSObject {
    
    func showViewPlayer(){
        if let keyWindow = UIApplication.sharedApplication().keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .whiteColor()
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { 
                
                view.frame = keyWindow.frame
                
                }, completion: { (completedAnimation) in
                    // Do something here later
                    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
            })
        }
    }
}
