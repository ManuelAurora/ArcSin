
import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController
{
    
    // MARK:  - Properties
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        
        didSet {
            
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView.reloadData()
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController<NSFetchRequestResult>, style : UITableViewStyle = .plain) {
        fetchedResultsController = fc
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK:  - Subclass responsibility
extension CoreDataTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
}

// MARK:  - Table Data Source
extension CoreDataTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return fetchedResultsController?.sections?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return fetchedResultsController?.sections?[section].name ?? nil
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  fetchedResultsController?.sectionIndexTitles
    }
}

// MARK:  - Fetches
extension CoreDataTableViewController{
    
    func executeSearch(){
        
        do
        {
            try fetchedResultsController?.performFetch()
        }
        catch let e as NSError
        {
            print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
        }
    }
}



// MARK:  - Delegate
extension CoreDataTableViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type)
        {
        case .insert:
            tableView.insertSections(set as IndexSet, with: .fade)
            
        case .delete:
            tableView.deleteSections(set as IndexSet, with: .fade)
            
        default:
            
            break
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type)
        {
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
















