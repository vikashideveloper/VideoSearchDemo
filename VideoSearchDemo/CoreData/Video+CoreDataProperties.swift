//
//  VideoLike+CoreDataProperties.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 03/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension VideoLike {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoLike> {
        return NSFetchRequest<VideoLike>(entityName: "Video");
    }

    @NSManaged public var like: Bool
    @NSManaged public var videoID: String

}
