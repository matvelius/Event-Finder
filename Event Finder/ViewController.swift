//
//  ViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import UIKit
import Nuke

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTableDataSourceAndDelegate()
        
        self.fetchData(from: "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)", completion: { result in
            self.tableView.reloadData()
        })
    }
    
    func setTableDataSourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.allEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentEvent = Events.allEvents[indexPath.item]
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
