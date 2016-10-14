
import UIKit
import CoreData

class NewsTableViewController: CoreDataTableViewController
{
    let deviceStatusIdentifier = DeviceStatusIdentifier.sharedInstance()
    let networkRequestHandler  = NetworkRequestHandler.sharedInstance()
    
    let managedContext = DataManager.sharedInstance().context
    
    @IBAction func action(_ sender: AnyObject) {
        networkRequestHandler.requestData(isRequestUid: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        deviceStatusIdentifier.getCurrentLocation()
        
//        let params: [String: AnyObject] = ["full_text": "dsfdsfdsfDSFs dfk dsfk dslfk d;lskf l;sdkflsdkf sdlf ksdlf ksd;fk dslfk dslkfdsf dsf sdf dsf dsfsdf sdf" as AnyObject,
//                      "header": "Header" as AnyObject,
//                      "id": 332 as AnyObject,
//                      "change_datetime": "13-12-2016 12:45:45" as AnyObject,
//                      "short_text":  "ASd asd asdsa asdsad sad asd sad saa s as " as AnyObject,
//                      "publish_time":"13-12-2016 12:45:45" as AnyObject,
//                      "img_url": "https://avatars2.githubusercontent.com/u/16256233?v=3&s=64" as AnyObject,
//                      "img_preview_url": "https://avatars2.githubusercontent.com/u/16256233?v=3&s=64" as AnyObject,
//                      "content_type_id": 1 as AnyObject]
//            
//          _ = News(with: params)
        
  //      try! DataManager.sharedInstance().saveContext()
        
        fetchData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableViewCell
        
        let news = fetchedResultsController?.object(at: indexPath as IndexPath) as! News
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale    = .current
        
        var tint = UIColor()
        var label = ""
        
        switch news.contentID {
        case 0:
            tint = UIColor.orange
            label = "Новость"
        case 1:
            tint = UIColor.blue
            label = "Акция"
        case 2:
            tint = UIColor.green
            label = "Спецпредложение"
        default:
            break
        }
        
        cell.dateLabel.textColor = tint
        cell.dateLabel.text = "\(label), " + formatter.string(from: news.publicationDate! as Date)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController!.fetchedObjects!.count 
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsShow" else { return }
        
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        let controller = segue.destination as! NewsDetailViewController
        
        controller.news = fetchedResultsController?.object(at: indexPath!) as! News
    }
    
    func fetchData() {
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let sortDescriptor = NSSortDescriptor(key: "publicationDate", ascending: false)
        
        fetchRequest = NSFetchRequest(entityName: "News")
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
    }
}

