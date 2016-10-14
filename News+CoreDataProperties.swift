//
//  News+CoreDataProperties.swift
//  ArcSin
//
//  Created by Мануэль on 14.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News");
    }

    @NSManaged public var fullText: String?
    @NSManaged public var header: String?
    @NSManaged public var id: Int16
    @NSManaged public var largImage: NSData?
    @NSManaged public var lastChangeTime: NSDate?
    @NSManaged public var publicationDate: NSDate?
    @NSManaged public var shortText: String?
    @NSManaged public var smallImage: NSData?
    @NSManaged public var contentID: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var smallImageURL: String?

}
