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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {

        if favoriteButtonImageName == .favoriteBlank { // mark event as favorite
            
            if event != nil { addEventToFavorites(eventID: event!.id) }
            sender.setImage(UIImage(named: FavoriteImage.favorite.rawValue), for: .normal)
            favoriteButtonImageName = .favorite
            
        } else { // unmark favorite
            
            if event != nil { removeEventFromFavorites(eventID: event!.id) }
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
        
        if let imageURL = URL(string: event!.performers[0].image) {
            Nuke.loadImage(with: imageURL, into: self.eventImage)
        }
        
        eventTitleLabel.text = event!.shortTitle
        eventDateTimeLabel.text = getLocalDateTime(from: event!.datetimeUTC) ?? "n/a"
        eventLocationLabel.text = event!.venue.displayLocation
        
        favoriteButtonImageName = Events.isEventFavorite(event!.id) ? FavoriteImage.favorite : FavoriteImage.favoriteBlank
        
        favoriteButton.setImage(UIImage(named: favoriteButtonImageName.rawValue), for: .normal)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        parent.reloadData()
//    }
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
    
    func addEventToFavorites(eventID: Int) {
        
        if !Events.isEventFavorite(eventID) {
            let defaults = UserDefaults.standard
            
            if var favoriteEvents: [Int] = defaults.object(forKey: "favoriteEvents") as? [Int] {
                favoriteEvents.append(eventID)
                defaults.setValue(favoriteEvents, forKey: "favoriteEvents")
            }
        }
        
    }
    
    func removeEventFromFavorites(eventID: Int) {
        
        if Events.isEventFavorite(eventID) {
            let defaults = UserDefaults.standard
            
            if let favoriteEvents: [Int] = defaults.object(forKey: "favoriteEvents") as? [Int] {
                defaults.setValue(favoriteEvents.filter { $0 != eventID }, forKey: "favoriteEvents")
            }
            
            print("removed element \(eventID) from favorites")
            print("favorites are now: \(defaults.object(forKey: "favoriteEvents"))")
        }
        
    }
    
    
}
