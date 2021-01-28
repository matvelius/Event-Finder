//
//  DetailViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/27/21.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    
    var event: Event?
    var eventTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if event == nil { return }
        
        if let imageURL = URL(string: event!.performers[0].image) {
            Nuke.loadImage(with: imageURL, into: self.eventImage)
        }
        
        eventTitleLabel.text = event!.shortTitle
        eventDateTimeLabel.text = getLocalDateTime(from: event!.datetimeUTC) ?? "n/a"
        eventLocationLabel.text = event!.venue.displayLocation
    }
}

extension DetailViewController {
    
    func getLocalDateTime(from dateTimeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, dd MMM YYYY @ h:mm a"
        
        return dateFormatter.string(from: date)
    }

}
