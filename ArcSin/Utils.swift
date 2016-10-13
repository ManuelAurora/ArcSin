//
//  Utils.swift
//  i-Partner
//
//  Created by Мануэль on 03.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit


struct Network
{
    static let url = "http://service-retailmob.rhcloud.com/api/v1/mobclient/register"
                        
    struct URLParameterKey
    {
        static let appKey = "app_key"
        static let packageName = "package_name"
        static let appVersion = "app_version"
        static let deviceType  = "devicetype"
        static let latitude    = "latitude"
        static let longitude   = "longitude"
        static let deviceVersion = "deviceversion"
        static let deviceModel   = "devicemodel"
        static let screenWidth = "screenwidth"
        static let screenHeight = "screenheight"
        static let aiUid = "aiuid"
        static let uid = "UID"
        static let lastSession = "last_session_datetime"
        static let contentTypeId = "content_type_id"
        static let fromId = "from_id"
        static let max = "max"
    }
    
    struct URLParameterValue {
        static let appKey = "04f0f542ea27a58461a44fbd75a89b30"
        static let packageName = "ru.arcsinus.SalesBlast"
        static let appVersion = "1.1.0"
        static let deviceType  = "0"
        static let lastSession = "0"
        static let contentTypeId = "0"
        static let fromId = "0"
        static let max = "100"
    }
    
}
