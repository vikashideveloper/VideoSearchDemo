//
//  VideoPlayerVC.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerVC: UIViewController {
    @IBOutlet var thumbImageView: UIImageView!
    
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
    var video:GiphyVideo!
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbImageView.image = video.downloadedImage
        imgViewHeight.constant = video.height
      
        if let videoURL = URL(string: video.mp4Url) {
            let avPlayer = AVPlayer(url: videoURL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(avPlayerLayer)
            avPlayer.play()
            
        } else {
            //
        }
        
    }
    
    @IBAction func back_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
