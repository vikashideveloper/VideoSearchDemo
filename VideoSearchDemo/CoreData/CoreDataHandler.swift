//
//  File.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 03/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation
import CoreData

class CDHelper {
    static let shared = CDHelper()
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func likeUnlikeVideo(_ video: GiphyVideo, block: (Bool)->Void) {
        do {
            if let vdo = getVideoLike(video.id) {
                vdo.like = video.youLike
            } else {
                let vdo = NSEntityDescription.insertNewObject(forEntityName: "VideoLike", into: context) as! VideoLike
                vdo.like = video.youLike
                vdo.videoID  = video.id
            }
            
            try context.save()
            block(true)
            
        } catch let error {
            print(error.localizedDescription )
            block(false)
        }
    }
    
    //Get videoLike by video id.
    func getVideoLike(_ videoID: String)-> VideoLike? {
        let predicate = NSPredicate(format: "videoID = %@", videoID)
        let req = NSFetchRequest<VideoLike>(entityName: "VideoLike")
        req.predicate = predicate

        do {
            let result = try context.fetch(req)
            return result.first
            
        } catch let error {
            print(error.localizedDescription )
           return nil
        }

    }
}
