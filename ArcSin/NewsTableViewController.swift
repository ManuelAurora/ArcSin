
import UIKit

class NewsTableViewController: CoreDataTableViewController
{
    let deviceStatusIdentifier = DeviceStatusIdentifier.sharedInstance()
    let networkRequestHandler  = NetworkRequestHandler.sharedInstance()
    
    var newsArray = [News]()
    
    @IBAction func action(_ sender: AnyObject) {
        networkRequestHandler.requestData(isRequestUid: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        deviceStatusIdentifier.getCurrentLocation()
        networkRequestHandler.requestData(isRequestUid: false)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = NewsTableViewCell()
       
        let news = newsArray[indexPath.row]
        
        cell.fullTextLabel.text = news.fullText!
        cell.headerLabel.text = news.header!
        cell.shortTextLabel.text = news.shortText!
        cell.imageView?.image = networkRequestHandler.requestImage(with: URL(string: news.smallImage!)!)
        
        return cell
    }
    
    
}

