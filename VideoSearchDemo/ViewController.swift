//
//  ViewController.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collView: UICollectionView!
    var videos = [GiphyVideo]()
    
    var listPresenter: VideoListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listPresenter = VideoListPresenter(view: self)
        listPresenter?.getVideos(by: "")
    }
}

//MARK: CollectionView DataSource and Delegate
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCardCell
        cell.backgroundColor = UIColor.gray
        let item = videos[indexPath.row]
       
        if let image = item.downloadedImage {
            cell.imgView.image = image
        } else {
            cell.imgView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemInRow:CGFloat = 4
        let sectionInset:CGFloat = 10 + 10
        let width = (collectionView.frame.width - (sectionInset + ((numberOfItemInRow-1) * 10)))/numberOfItemInRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        downloadImagesForVisibleCells()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        downloadImagesForVisibleCells()
    }
    
    func downloadImagesForVisibleCells() {
        for cell in collView.visibleCells as! [VideoCardCell] {
            let indexPath = collView.indexPath(for: cell)!
            let video = videos[indexPath.item]
            if let image = video.downloadedImage {
             cell.imgView.image = image
            } else {
                cell.imgView.image = nil
                loadThumImageFor(video: video, for: indexPath)
            }
        }
    }
    
    func loadThumImageFor(video: GiphyVideo, for indexPath: IndexPath) {
        if let url = URL(string: video.thumbUrl) {
            if let cell = collView.cellForItem(at: indexPath) as? VideoCardCell {
                cell.imgView.setImage(url: url, placeholder: nil, completion: { image in
                    video.downloadedImage = image
                })
            }
        }

    }
}

extension ViewController : VideoListView {
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
    func setListItem(videos: [GiphyVideo]) {
        print(videos)
        self.videos = videos
        collView.reloadData()
    }
}



