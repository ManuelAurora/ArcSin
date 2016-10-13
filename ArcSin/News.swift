//
//  News.swift
//  ArcSin
//
//  Created by Мануэль on 13.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

class News
{
    let lastChangeTime: Date?
    let fullText: String?
    let header: String?
    let id: Int?
    let smallImage: String?
    let largeImg: String?
    let publicationDate: Date?
    let shortText: String?
    
    init(with dict: [String: AnyObject]) {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-ll-yyyy hh:mm:ss"
        
        fullText = dict["full_text"] as? String ?? ""
        header = dict["header"] as? String ?? ""
        id = dict["id"] as? Int ?? nil
        shortText = dict["short_text"] as? String ?? ""
        lastChangeTime = formatter.date(from: dict["change_datetime"] as! String)
        publicationDate = formatter.date(from: dict["publish_time"] as! String)
        smallImage = dict["img_preview_ulr"] as? String ?? nil
        largeImg = dict["img_url"] as? String ?? nil
    }
    
    
}
