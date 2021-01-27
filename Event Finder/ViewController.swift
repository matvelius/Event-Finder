//
//  ViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import UIKit
import Nuke

class ViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        Events.filteredEvents.removeAll(keepingCapacity: false)
//
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (Events.filteredEvents as NSArray).filtered(using: searchPredicate)
//        Events.filteredEvents = array as! [String]
        Events.filteredEvents = searchController.searchBar.text!.isEmpty ? Events.allEvents : Events.allEvents.filter { $0.shortTitle.contains(searchController.searchBar.text!) }

        self.tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTableDataSourceAndDelegate()
        
        self.fetchData(from: "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)", completion: { result in
            self.tableView.reloadData()
        })
        
//        setUpSearchBar()
        
        Events.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
//            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()
        
        tableView.reloadData()
    }
    
    func setTableDataSourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setUpSearchBar() {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchBar
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (Events.searchController.isActive) {
            return Events.filteredEvents.count
          } else {
              return Events.allEvents.count
          }
//        return Events.allEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentEvent = Events.searchController.isActive ? Events.filteredEvents[indexPath.item] : Events.allEvents[indexPath.item]
        let imageURL = URL(string: currentEvent.performers[0].image)
        
        // configure cell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        Nuke.loadImage(with: imageURL!, into: cell.eventImage)
        cell.title.text = currentEvent.shortTitle
        cell.location.text = currentEvent.venue.name
        cell.date.text = getDate(from: currentEvent.datetimeUTC) ?? "n/a"
        cell.time.text = getLocalTime(from: currentEvent.datetimeUTC) ?? "n/a"
        
        return cell
    }

}


extension ViewController {
    
    func getDate(from dateTimeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, dd MMM YYYY"
        
        return dateFormatter.string(from: date)
    }
    
    func getLocalTime(from dateTimeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date)
    }

}
