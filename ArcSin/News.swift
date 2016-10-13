//
//  News.swift
//  ArcSin
//
//  Created by Мануэль on 13.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class News: NSManagedObject
{
    @NSManaged var lastChangeTime: Date?
    @NSManaged var fullText: String?
    @NSManaged var header: String?
    @NSManaged var id: NSNumber?
    @NSManaged var smallImage: NSData?
    @NSManaged var largeImg: NSData?
    @NSManaged var publicationDate: Date?
    @NSManaged var shortText: String?
    
    var smallImageURL: String?
    var imageURL: String?
    
    init(with dict: [String: AnyObject]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "News", in: DataManager.sharedInstance().context)
        
       super.init(entity: entity!, insertInto: DataManager.sharedInstance().context)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        
        fullText = dict["full_text"] as? String ?? ""
        header = dict["header"] as? String ?? ""
        id = dict["id"] as? NSNumber ?? nil
        shortText = dict["short_text"] as? String ?? ""
        lastChangeTime = formatter.date(from: dict["change_datetime"] as! String)
        publicationDate = formatter.date(from: dict["publish_time"] as! String)
        smallImageURL = dict["img_preview_ulr"] as? String ?? nil
        imageURL = dict["img_url"] as? String ?? nil
    }
    
    
}
