//
//  VideoListView.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation

protocol VideoListView: class {
    func startLoading()
    func stopLoading()
    func setListItem(videos: [GiphyVideo])
}


class VideoListPresenter {
    weak var listView: VideoListView?
    var service: VideoListService?
    
    init(view: VideoListView) {
        listView = view
        
    }
    
    func getVideos(by keyword: String) {
        listView?.startLoading()
        APICall.shared.search(keyword: keyword) { (json, success, error) in
            self.listView?.stopLoading()
            if success {
                if let json = json as? [String : Any] {
                    if let jsonResults = json["data"] as? [[String : Any]] {
                        let videoList = jsonResults.map({GiphyVideo($0)})
                        self.listView?.setListItem(videos: videoList)
                    } else {
                        self.listView?.setListItem(videos: [])
                    }
                } else {
                    self.listView?.setListItem(videos: [])
                }
                
            } else {
                
            }
        }
    }
}

class VideoListService {
    
}
