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
        if let imgURL = news.imageURL
        {
            imageView.image = NetworkRequestHandler.sharedInstance().requestImage(with: URL(string: imgURL)!)
        }
        
        fullTextView.text = news.fullText!
        
        dateLabel.text = news.publicationDate!.description
    }
}
