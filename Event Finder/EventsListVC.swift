//
//  ViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import UIKit
import Nuke

class EventsListVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        Events.filteredEvents = searchController.searchBar.text!.isEmpty ? Events.allEvents : Events.allEvents.filter { $0.shortTitle.contains(searchController.searchBar.text!) }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableDataSourceAndDelegate()
        
        self.fetchData(from: "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)", completion: { result in
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
        
        let currentEvent = Events.searchController.isActive ? Events.filteredEvents[indexPath.item] : Events.allEvents[indexPath.item]
        let imageURL = URL(string: currentEvent.performers[0].image)
        
        // configure cell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        Nuke.loadImage(with: imageURL!, into: cell.eventImage)
        cell.title.text = currentEvent.shortTitle
        cell.location.text = currentEvent.venue.displayLocation
        cell.date.text = getDate(from: currentEvent.datetimeUTC) ?? "n/a"
        cell.time.text = getLocalTime(from: currentEvent.datetimeUTC) ?? "n/a"
        
        // favorite icon
        if Events.isEventFavorite(currentEvent.id) {
            cell.favoriteIcon.image = UIImage(named: FavoriteImage.favorite.rawValue)
        } else {
            cell.favoriteIcon.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC
        
        let currentEvent = Events.searchController.isActive ? Events.filteredEvents[indexPath.row] : Events.allEvents[indexPath.row]

        detailVC?.event = currentEvent
        
        detailVC?.eventTitle = currentEvent.shortTitle
                
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    
}


extension EventsListVC {
    
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
