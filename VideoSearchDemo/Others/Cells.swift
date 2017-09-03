//
//  Cells.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 28/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class VideoCardCell: UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnLike: UIButton!
    
    func setVideoData(_ video: GiphyVideo) {
        if let thumbURl = URL(string: video.thumbUrl) {
            imgView.setImage(url: thumbURl)
        } else {
            //set default image
            imgView.image = nil
        }
    }
    
    func setLikeBtn(isLike: Bool) {
        btnLike.tintColor = isLike ? UIColor.green : UIColor.gray
    }
}
