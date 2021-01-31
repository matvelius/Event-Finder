//
//  EventCell.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import UIKit
import Nuke

class EventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
}

extension EventsListVC {
    func configureCell(_ cell: EventCell, for index: Int) -> EventCell {
        let currentEvent = Events.searchController.isActive ? Events.filteredEvents[index] : Events.allEvents[index]
        let imageURL = URL(string: currentEvent.performers[0].image)
        
        Nuke.loadImage(with: imageURL!, into: cell.eventImage)
        cell.title.text = currentEvent.shortTitle
        cell.location.text = currentEvent.venue.displayLocation
        cell.date.text = DateTime.getDate(from: currentEvent.datetimeUTC) ?? "n/a"
        cell.time.text = DateTime.getLocalTime(from: currentEvent.datetimeUTC) ?? "n/a"
        
        // favorite icon
        if Events.isEventFavorite(currentEvent.id) {
            cell.favoriteIcon.image = UIImage(named: FavoriteImage.favorite.rawValue)
        } else {
            cell.favoriteIcon.image = nil
        }
        
        return cell
    }
}
