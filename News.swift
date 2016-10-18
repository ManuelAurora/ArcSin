//
//  News+CoreDataClass.swift
//  ArcSin
//
//  Created by Мануэль on 14.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class News: NSManagedObject
{  
    
    convenience init(with dict: [String: AnyObject]) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entity(forEntityName: "News", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"        
        formatter.formatterBehavior = .default
        
        fullText = dict["full_text"] as? String
        header = dict["header"] as? String
        id = Int16(dict["id"] as! Int)
        shortText = dict["short_text"] as? String
        lastChangeTime = formatter.date(from: dict["change_datetime"]! as! String) as NSDate?
        publicationDate = formatter.date(from: dict["publish_time"] as! String) as NSDate?
        smallImageURL = dict["img_preview_url"] as? String
        
        if let string = (dict["img_url"] as? String) {
            imageURL =  pretty(urlString: string)
        }
        
        contentID = Int16(dict["content_type_id"] as! Int)
        link = dict["link"] as? String
    }

    private func pretty(urlString: String) -> String {
        
        let startIndex = urlString.index(urlString.startIndex, offsetBy: 2)
        let endIndex   = urlString.index(urlString.endIndex, offsetBy: -3)
        
        let pretty = urlString[startIndex...endIndex]
        
        return pretty
    }
}
