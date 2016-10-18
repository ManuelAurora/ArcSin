//
//  NewsDetailViewController.swift
//  ArcSin
//
//  Created by Мануэль on 13.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class NewsDetailViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var fullTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    var news: News!
    
    @IBAction func tappedOnImage(_ sender: UITapGestureRecognizer) {
       
        let app = UIApplication.shared
        let url = news.link

        guard let link = url, link.contains("http://") || link.contains("https://") else { return }
       
        app.open(URL(string: link)!, options: [:], completionHandler: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = news.largImage
        {
            imageView.image = UIImage(data: imageData as Data)
        }
        if let imgUrlString = news.imageURL,
            let url   = URL(string: imgUrlString),
            let image = NetworkRequestHandler.sharedInstance().requestImage(with:url) {
            
            imageView.image = image
        }
        
        if let header = news.header
        {
            headerLabel.text = header
        }
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale    = .current
        
        fullTextView.text = news.fullText!
        if let date = news.publicationDate as? Date
        {
            dateLabel.text = formatter.string(from: date)
        }
    }
}
