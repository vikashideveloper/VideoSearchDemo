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
    
    let sectionInsetValue:CGFloat = 8
    let itemSpacing:CGFloat = 8
    
    var listPresenter: VideoListPresenter?
    let transition = CustomTranstion()

    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listPresenter = VideoListPresenter(view: self)
        listPresenter?.getVideos(by: "")
        transition.delegate = self

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playerVC = segue.destination as! VideoPlayerVC
        playerVC.transitioningDelegate = self
        playerVC.modalPresentationStyle = .custom
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
            if !collectionView.isDragging && !collectionView.isDecelerating {
                self.loadThumImageFor(video: item, for: cell)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "toPlayerVCSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemInRow:CGFloat = 4
        let sectionInset:CGFloat = sectionInsetValue * 2
        let width = (collectionView.frame.width - (sectionInset + ((numberOfItemInRow-1) * itemSpacing)))/numberOfItemInRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInsetValue, left: sectionInsetValue, bottom: sectionInsetValue, right: sectionInsetValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        downloadImagesForVisibleCells()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            downloadImagesForVisibleCells()
        }
    }
    
    func downloadImagesForVisibleCells() {
        for cell in collView.visibleCells as! [VideoCardCell] {
            let indexPath = collView.indexPath(for: cell)!
            let video = videos[indexPath.item]
            if let image = video.downloadedImage {
             cell.imgView.image = image
            } else {
                cell.imgView.image = nil
                loadThumImageFor(video: video, for: cell)
            }
        }
    }
    
    func loadThumImageFor(video: GiphyVideo, for cell: VideoCardCell) {
        if let url = URL(string: video.thumbUrl) {
            cell.imgView.setImage(url: url, placeholder: nil, completion: { image in
                video.downloadedImage = image
                cell.imgView.image = image
            })
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


extension ViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionModelState = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionModelState = .dismiss

        return transition
    }
    
}

extension ViewController: CustomTranstionDelegate {
    func animatingImage() -> UIImage? {
        if let indexPath = selectedIndexPath {
            if let cell = collView.cellForItem(at: indexPath) as? VideoCardCell {
                return cell.imgView.image
            }
        }
        return nil
    }
    
    func animationStartFrame() -> CGRect {
        if let indexPath = selectedIndexPath {
            if let cell = collView.cellForItem(at: indexPath) as? VideoCardCell {
                let frm = self.view.convert(cell.bounds, from: cell)
                return frm
            }
        }
        return .zero

    }
    
    func animationEndFrame() -> CGRect {
        let y = self.view.frame.height/2 - 100
        return CGRect(x: 0, y: y, width: self.view.frame.width, height: 200)
    }
}



