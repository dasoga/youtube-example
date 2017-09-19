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
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pauseButton")
        button.setImage(image, for: UIControlState())
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let videoTotalLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var videoSlider:UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: UIControlState())
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
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
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoTotalLengthLabel)
        videoTotalLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoTotalLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoTotalLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoTotalLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoCurrentTimeLabel)
        videoCurrentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        videoCurrentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoCurrentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoCurrentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraint(equalTo: videoCurrentTimeLabel.rightAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: videoTotalLengthLabel.leftAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPlayerView(){
        let urlString = "https://firebasestorage.googleapis.com/v0/b/chatrealtime-1e87d.appspot.com/o/message_movies%2F1EEC633D-F705-498C-8971-17C984A62FB7.mov?alt=media&token=fecdf347-0790-4f67-b4ee-7d84fce4a6d2"
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
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
    
    fileprivate func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
            
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicator.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
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
            pausePlayButton.setImage(UIImage(named: "playButton"), for: UIControlState())
        }else{
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pauseButton"), for: UIControlState())
        }
        
        isPlaying = !isPlaying
    }
    
    func handleSliderChange(){
//        print(videoSlider.value)
        if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // Do something later here
            })
            
        }
    }
    
    
}

class VideoLauncher: NSObject {
    
    func showViewPlayer(){
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                
                view.frame = keyWindow.frame
                
                }, completion: { (completedAnimation) in
                    // Do something here later
                    UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
}
