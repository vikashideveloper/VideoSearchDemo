//
//  VideoPlayerVC.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerVC: UIViewController {
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
    var video:GiphyVideo!
    var avPlayer: AVPlayer!
    var avLayer: AVPlayerLayer!
    var playerVC: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbImageView.image = video.downloadedImage
        imgViewHeight.constant = video.height
      
        if let videoURL = URL(string: video.mp4Url) {
                avPlayer = AVPlayer(url: videoURL)
                avLayer = AVPlayerLayer(player: avPlayer)
                avLayer.frame = self.view.bounds
                self.view.layer.addSublayer(avLayer)
                avPlayer.play()
            
        } else {
            //
        }
        
    }
    
    
    @IBAction func back_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        var fr = avLayer.frame
        fr.size = size
        avLayer.frame = fr
    }
    
}

