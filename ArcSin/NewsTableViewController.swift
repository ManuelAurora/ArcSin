
import UIKit
import CoreData

class NewsTableViewController: CoreDataTableViewController
{
    let deviceStatusIdentifier = DeviceStatusIdentifier.sharedInstance()
    let networkRequestHandler  = NetworkRequestHandler.sharedInstance()
    
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = NewsTableViewCell()
       
        let news = fetchedResultsController?.object(at: indexPath as IndexPath) as! News
        
        cell.fullTextLabel.text = news.fullText!
        cell.headerLabel.text = news.header!
        cell.shortTextLabel.text = news.shortText!
        
        if news.smallImage == nil
        {
            cell.imageView?.image = networkRequestHandler.requestImage(with: URL(string: news.smallImageURL!)!)
        }
        else
        {
            cell.imageView?.image = UIImage(data: news.smallImage! as Data)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsShow" else { return }
        
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        let controller = segue.destination as! NewsDetailViewController
        
        controller.news = fetchedResultsController?.object(at: indexPath!) as! News
    }
}

