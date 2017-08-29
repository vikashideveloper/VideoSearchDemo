//
//  GiphyModels.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class GiphyVideo {
    var id = ""
    var thumbUrl = ""
    var mp4Url = ""
    var downloadedImage: UIImage?
    
    init(_ json: [String : Any]) {
        id = (json["id"] as? String) ?? ""
        thumbUrl = (json["images"] as? [String : [String : String]])?["downsized_still"]?["url"] ?? ""
        mp4Url = (json["images"] as? [String : [String : String]])?["fixed_height"]?["mp4"] ?? ""
    }
}
