//
//  ScreenSaverViewController.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 14/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import AVKit

protocol ScreenSaverDelegate: NSObjectProtocol {
    func didDismiss()
}

class ScreenSaverViewController: AVPlayerViewController {
    
    private var timeObserver: Any!
    
    open weak var screenDelegate: ScreenSaverDelegate?
    
    private var initialTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "ScreenSaver", ofType: "mp4")
        let url = NSURL.fileURL(withPath: path!)
        let avAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: avAsset)
        player = AVPlayer(playerItem: playerItem)
        
        self.showsPlaybackControls = false
        
//        let time = NSValue(time: CMTime(seconds: 2, preferredTimescale: 1))
        
        self.timeObserver = self.player?.addBoundaryTimeObserver(forTimes: [NSValue(time: avAsset.duration)], queue: .main, using: {
            if let time = self.initialTime {
                if Date().timeIntervalSince1970 - time >= 1200 {
                    self.dismiss()
                }
            } else {
                self.initialTime = Date().timeIntervalSince1970
            }
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        })
                
        // Setup Menu Button recognizer
        let menuGesture = UITapGestureRecognizer(target: self, action: #selector(ScreenSaverViewController.handleMenuGesture(tap:)))
        menuGesture.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuGesture)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initialTime = Date().timeIntervalSince1970
        self.player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.player?.removeTimeObserver(self.timeObserver)
        self.timeObserver = nil
        self.player?.replaceCurrentItem(with: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
    
    // MARK: - Handle Siri Remote Menu Button
    @objc func handleMenuGesture(tap: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: {
            self.screenDelegate?.didDismiss()
        })
    }
    
}
