//
//  DetailViewController.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/27/21.
//

import UIKit
import Nuke

class EventDetailVC: UIViewController {
    

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {

        if favoriteButtonImageName == .favoriteBlank { // mark event as favorite
            
            if event != nil { Events.addEventToFavorites(eventID: event!.id) }
            sender.setImage(UIImage(named: FavoriteImage.favorite.rawValue), for: .normal)
            favoriteButtonImageName = .favorite
            
        } else { // unmark favorite
            
            if event != nil { Events.removeEventFromFavorites(eventID: event!.id) }
            sender.setImage(UIImage(named: FavoriteImage.favoriteBlank.rawValue), for: .normal)
            favoriteButtonImageName = .favoriteBlank
            
        }

    }
        
    var event: Event?
    var eventTitle: String?
    
    var favoriteButtonImageName = FavoriteImage.favoriteBlank
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if event == nil { return }
        setupView()
    }
    
    func setupView() {
        if let imageURL = URL(string: event!.performers[0].image) {
            Nuke.loadImage(with: imageURL, into: self.eventImage)
        }
        
        eventTitleLabel.text = event!.shortTitle
        eventDateTimeLabel.text = getLocalDateTime(from: event!.datetimeUTC) ?? "n/a"
        eventLocationLabel.text = event!.venue.displayLocation
        
        favoriteButtonImageName = Events.isEventFavorite(event!.id) ? FavoriteImage.favorite : FavoriteImage.favoriteBlank
        favoriteButton.setImage(UIImage(named: favoriteButtonImageName.rawValue), for: .normal)
        
        Events.searchController.isActive = false
    }
}

extension EventDetailVC {
    
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
