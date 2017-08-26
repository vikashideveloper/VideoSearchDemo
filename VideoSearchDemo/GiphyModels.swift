//
//  GiphyModels.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation

struct GiphyVideo {
    var id = ""
    var thumbUrl = ""
    var mp4Url = ""
    
    init(_ json: [String : Any]) {
        id = (json["id"] as? String) ?? ""
        thumbUrl = (json["images"] as? [String : [String : String]])?["fixed_height"]?["url"] ?? ""
        mp4Url = (json["images"] as? [String : [String : String]])?["fixed_height"]?["mp4"] ?? ""
    }
}
