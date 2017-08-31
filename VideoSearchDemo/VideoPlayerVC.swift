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
      
        let videoURL = NSURL(string: video.mp4Url)
        let playerAV = AVPlayer(url: videoURL! as URL)
        let playerLayerAV = AVPlayerLayer(player: playerAV)
        playerLayerAV.frame = self.view.bounds
        //playerLayerAV.contentsGravity = kCAGravityCenter
        self.view.layer.addSublayer(playerLayerAV)
        playerAV.play()
        
        
    }
    
    @IBAction func back_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
