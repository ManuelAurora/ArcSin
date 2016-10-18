
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
        
        let nib = UINib(nibName: "NewsCellView", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
               
        fetchData()
        
        networkRequestHandler.allNews = fetchedResultsController?.fetchedObjects as! [News]
        
        tableView.estimatedRowHeight = 110.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        deviceStatusIdentifier.getCurrentLocation()
        
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
        cell.dateLabel.text = "\(label)"
        
        if let publicDate = news.publicationDate
        {
            let text = ["\(label)", formatter.string(from: publicDate as Date)]
            
            cell.dateLabel.text = text.joined(separator: ", ")
        }
        
        cell.headerLabel.text = news.header ?? ""
        cell.shortTextLabel.text = news.shortText ?? ""
        
        if news.smallImage == nil
        {
            if let imageUrlString = news.smallImageURL,
                let url = URL(string: imageUrlString),
                let image = networkRequestHandler.requestImage(with: url) {
                
                cell.imageView?.image = image
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Storyboard.showDetail, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == Storyboard.showDetail else { return }
        
        let controller = segue.destination as! NewsDetailViewController
        
        let indexPath = sender as! IndexPath
        
        controller.news = fetchedResultsController?.object(at: indexPath) as! News
    }
    
    func fetchData() {
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let sortDescriptor = NSSortDescriptor(key: "publicationDate", ascending: false)
        
        fetchRequest = NSFetchRequest(entityName: "News")
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
    }
}

