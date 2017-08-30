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
    func setListItem(videos: [GiphyVideo], totalItems: Int)
}


class VideoListPresenter {
    weak var listView: VideoListView?
    
    init(view: VideoListView) {
        listView = view
        
    }
    
    func getVideos(by keyword: String, offset: Int, limit: Int) {
        listView?.startLoading()
        APICall.shared.search(keyword: keyword, offset: offset, limit: limit) { (json, success, error) in
            self.listView?.stopLoading()
            if success {
                if let json = json as? [String : Any] {
                    let totlaCount = (json["pagination"] as? [String : Int])?["total_count"] ?? 0
                    
                    if let jsonResults = json["data"] as? [[String : Any]] {
                        let videoList = jsonResults.map({GiphyVideo($0)})
                        self.listView?.setListItem(videos: videoList, totalItems: totlaCount)
                    } else {
                        self.listView?.setListItem(videos: [], totalItems: 0)
                    }
                } else {
                    self.listView?.setListItem(videos: [], totalItems: 0)
                }
                
            } else {
                
            }
        }
    }
}

