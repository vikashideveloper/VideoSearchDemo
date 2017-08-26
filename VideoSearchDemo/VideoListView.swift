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
    func setVideos()
    func error()
}


class VideoListPresenter {
    weak var videoListView: VideoListView?
    
}
