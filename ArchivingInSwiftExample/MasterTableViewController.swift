//
//  MasterTableViewController.swift
//  Archiving
//
//  Created by Alex Gibson on 12/11/14.
//  Copyright (c) 2014 Alex Gibson . All rights reserved.
//

import UIKit


class MasterTableViewController: UITableViewController,UIViewControllerTransitioningDelegate,UISearchBarDelegate  {

    
    // will be used when the user does a search
    var searchDiaryEntries = [AnyObject]()
    // just used for segue to new viewcontroller but this variable is not necessary
    var selectedEntry : DiaryEntry!
    // our searchBar  iOS 8
    @IBOutlet weak var searchBar: UISearchBar!
    
    // I don't know if Swift looks cleaner than Objective C or not. I am warming to Swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchbar
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        // just a way to reload the table from other views
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadOurTable", name: "reloadPlease", object: nil)

    }
    
    // this is just so we can call reload with the notification center
    func reloadOurTable()
    {
        
        self.tableView.reloadData()
    }
    
   

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //pretty status bar
        //because we like a beautiful status bar
        self.navigationController?.navigationBar.barStyle
        
        //hide our searchbar and activate it when the user pulls down on the table
        self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if tableView == self.searchDisplayController?.searchResultsTableView{
                return searchDiaryEntries.count
                
            }
            else
            {
                // just returning our singleton array count here
                //println("The count is now \(DiaryEntryStore.sharedInstance.diaryEntries.count)")
                return DiaryEntryStore.sharedInstance.diaryEntries.count
                
            }
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            var entry :DiaryEntry
            
            if tableView == self.searchDisplayController!.searchResultsTableView{
                entry = self.searchDiaryEntries[indexPath.row] as DiaryEntry
            }
            else
            {
                // getting the entry from the singleton array
                entry = DiaryEntryStore.sharedInstance.diaryEntries[indexPath.row] as DiaryEntry
            }
            
            
            cell.textLabel!.text = entry.title as String
            
            
            return cell
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if tableView == self.searchDisplayController!.searchResultsTableView{
            selectedEntry = self.searchDiaryEntries[indexPath.row] as DiaryEntry
        }
        else
        {
            selectedEntry = DiaryEntryStore.sharedInstance.diaryEntries[indexPath.row] as DiaryEntry
        }
        

        
        // perform seque with our entry
        self.performSegueWithIdentifier("_viewEntry", sender: self)
        
    }
    
    
    
    // Mark : UIViewControllerAnimatedTransitioning
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "_addNew"
        {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let dvc = storyboard.instantiateViewControllerWithIdentifier("detailsVC") as UIViewController
            //lets have some fun here
            let dvc : UIViewController = segue.destinationViewController as UIViewController
            dvc.transitioningDelegate = self
            dvc.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
        
        if segue.identifier == "_viewEntry"
        {
            let viewEntryVC = segue.destinationViewController as ViewArticleViewController
            viewEntryVC.entry = selectedEntry
        }
        
        
    }
    
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
           
            
                
                var entry :DiaryEntry
                //get our object we want to delete
                entry = DiaryEntryStore.sharedInstance.diaryEntries[indexPath.row] as DiaryEntry
                
                // remove the entry from our singleton and then reload
                DiaryEntryStore.sharedInstance.diaryEntries.removeObject(entry)
                //Reload our TableView
                self.tableView.reloadData()
                break;
            default:
                return
            }
    }
    
    
    
    
    
    
    // mark Searching
    // This is where we will search our color array
    func filterContentForSearchText(searchText: String) {
        
        // temp holding of our singleton array of entries
        var entries : NSArray = DiaryEntryStore.sharedInstance.diaryEntries
        
        //println(entries)
        // This is how you would search two properties of of a custom class.  The match the properties
        let predicate = NSPredicate(format: "title contains[c] %@ OR entry contains[c] %@", searchText,searchText)
        
        self.searchDiaryEntries = entries.filteredArrayUsingPredicate(predicate!)
        println(self.searchDiaryEntries)
        
        
    }
    
    // Reload the searchDisplayController  ???? I thought this was deprecated but it still works
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    // Dont really need this but why not
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    //dont need this either but why not
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
}
