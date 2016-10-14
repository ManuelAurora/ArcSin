//
//  NewsTableViewCell.swift
//  ArcSin
//
//  Created by Мануэль on 13.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!    
    
    override func didMoveToSuperview() {
        
        headerLabel.textColor = UIColor(red: 255/255, green: 71/255, blue: 76/255, alpha: 1)       
        
    }
}
