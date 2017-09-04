//
//  ViewController.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var videos = [GiphyVideo]()
    
    var loadMore = LoadMore()
    
    let sectionInsetValue:CGFloat = 8
    let itemSpacing:CGFloat = 8
    let numberOfItemInRow:CGFloat = 3
    
    var listPresenter: VideoListPresenter?
    let transition = CustomTranstion()

    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        listPresenter = VideoListPresenter(view: self)
        listPresenter?.getVideos(by: loadMore.searchTerm, offset: loadMore.offset, limit: loadMore.limit)
        transition.delegate = self
    }
    
    func loadMoreData() {
        if loadMore.canLoadMore {
            loadMore.isLoading = true
            listPresenter?.getVideos(by: loadMore.searchTerm, offset: loadMore.offset, limit: loadMore.limit)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playerVC = segue.destination as! VideoPlayerVC
        let indexPath = sender as! IndexPath
        playerVC.video = videos[indexPath.row]
        playerVC.transitioningDelegate = self
        playerVC.modalPresentationStyle = .custom
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collView.reloadData()
    }
    
}


//MARK:- IBActions
extension ViewController {
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        let video = videos[sender.tag]
        
        listPresenter?.likeUnLikeVideo(video, block: {[weak self] success in
            let indexPath = IndexPath(item: sender.tag, section: 0)
            if let cell = self?.collView.cellForItem(at: indexPath) as? VideoCardCell {
                cell.setLikeBtn(isLike: video.youLike)
            }
        })
    }

}

//MARK:- CollectionView DataSource and Delegate
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            let trimmedText = searchTerm.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                loadMore.reset()
                loadMore.searchTerm = trimmedText
                listPresenter?.getVideos(by: trimmedText, offset: loadMore.offset, limit: loadMore.limit)
            }
        }
    }
}


//MARK:- CollectionView DataSource and Delegate
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCardCell
        cell.backgroundColor = UIColor.black
        let item = videos[indexPath.row]
        
        cell.setLikeBtn(isLike: item.youLike)
        cell.btnLike.tag = indexPath.row
        
        if let image = item.downloadedImage {
            cell.imgView.image = image
        } else {
            cell.imgView.image = nil
            if !collectionView.isDragging && !collectionView.isDecelerating {
                self.loadThumImageFor(video: item, for: cell)
            }
        }
        
        //load more items 
        if indexPath.item == (videos.count-1) {
            self.loadMoreData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "toPlayerVCSegue", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    //MARK:- Download Thumbnail Images
    func downloadImagesForVisibleCells() {
        for cell in collView.visibleCells as! [VideoCardCell] {
            let indexPath = collView.indexPath(for: cell)!
            let video = videos[indexPath.item]
            
            if let _ = video.downloadedImage {
             //cell.imgView.image = image
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


//MARK:- VideoListView delegate
extension ViewController : VideoListView {
    func startLoading() {
        if loadMore.offset == 0 {
            loadingIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func setListItem(videos: [GiphyVideo], totalItems: Int) {
        
        if loadMore.offset == 0{// first page loading, reset videos array.
            self.videos.removeAll()
            self.videos = videos
            collView.reloadData()
            
        } else {
            var prevVideoCount = self.videos.count
            self.videos += videos

            let indexPaths = videos.map({ _ -> IndexPath in
                let index = IndexPath(item: prevVideoCount, section: 0)
                prevVideoCount += 1
                return index
            })
            
            collView.insertItems(at: indexPaths)
        }
        
        loadMore.offset += 1
        loadMore.isLoading = false
        loadMore.totalItemCount = totalItems
        loadMore.loadedItemCount += videos.count
    }
    
}


//MARK:- UIViewControllerTransitioningDelegate
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


//MARK:- CustomTranstionDelegate
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
        let imgHeight = videos[selectedIndexPath!.item].height
        let y = (self.view.frame.height/2) - (imgHeight/2)
        return CGRect(x: 0, y: y, width: self.view.frame.width, height: imgHeight)
    }
}


//MARK:- LoadMore
struct LoadMore {
    var searchTerm = "India" //Default term
    var limit = 50
    var offset = 0
    var totalItemCount = 0
    var loadedItemCount = 0
    var isLoading = false
    
    var canLoadMore: Bool {
        return (loadedItemCount < totalItemCount) && !isLoading
    }
    
    mutating func reset() {
        offset = 0
        totalItemCount = 0
        loadedItemCount = 0
    }
}



