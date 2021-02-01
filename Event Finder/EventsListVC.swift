//
//  ViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import UIKit

class EventsListVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableDataSourceAndDelegate()
        
        
        self.fetchData(from: Secrets.URL, completion: { result in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTableDataSourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: UITableView setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (Events.searchController.isActive) {
            return Events.filteredEvents.count
        } else {
            return Events.allEvents.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        return configureCell(cell, for: indexPath.item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC
        
        let currentEvent = Events.searchController.isActive ? Events.filteredEvents[indexPath.row] : Events.allEvents[indexPath.row]

        detailVC?.event = currentEvent
        detailVC?.eventTitle = currentEvent.shortTitle
                
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    
}

// search functionality
extension EventsListVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        Events.filteredEvents = searchController.searchBar.text!.isEmpty ? Events.allEvents : Events.allEvents.filter { $0.shortTitle.contains(searchController.searchBar.text!) }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setUpSearchBar() {
        Events.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
}
