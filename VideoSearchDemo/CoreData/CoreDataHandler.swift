//
//  File.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 03/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler {
    static let shared = CoreDataHandler()
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func likeUnlikeVideo(_ video: GiphyVideo, block: (Bool)->Void) {
        let predicate = NSPredicate(format: "videoID = %@", video.id)
        let req = NSFetchRequest<VideoLike>(entityName: "Video")
        req.predicate = predicate
        
        do {
            let result = try context.fetch(req)
            if let vdo = result.first {
                vdo.like = video.youLike
            } else {
                let vdo = VideoLike(context: context)
                vdo.like = video.youLike
            }
            
            try context.save()
            
        } catch let error {
            print(error.localizedDescription )
        }
    }
}
