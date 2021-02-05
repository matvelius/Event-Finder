//
//  Events.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/24/21.
//

import UIKit

struct Events {
    // store all events
    static var allEvents = [Event]()
    
    // searching:
    static var searchedEvents = [Event]()
    static var searchController = UISearchController()
    
    // keeping track of favorites:
    static func isEventFavorite(_ eventID: Int) -> Bool {
        let defaults = UserDefaults.standard
        
        if let favoriteEvents: [Int] = defaults.object(forKey: "favoriteEvents") as? [Int] {
            if favoriteEvents.contains(eventID) {
                return true
            }
        }
        
        return false
    }
    
    static func addEventToFavorites(eventID: Int) {
        
        if !isEventFavorite(eventID) {
            let defaults = UserDefaults.standard
            
            if var favoriteEvents: [Int] = defaults.object(forKey: "favoriteEvents") as? [Int] {
                favoriteEvents.append(eventID)
                defaults.setValue(favoriteEvents, forKey: "favoriteEvents")
            }
        }
        
    }
    
    static func removeEventFromFavorites(eventID: Int) {
        
        if isEventFavorite(eventID) {
            let defaults = UserDefaults.standard
            
            if let favoriteEvents: [Int] = defaults.object(forKey: "favoriteEvents") as? [Int] {
                defaults.setValue(favoriteEvents.filter { $0 != eventID }, forKey: "favoriteEvents")
            }
            
        }
        
    }

}

// MARK: - RawResponse
struct RawResponse: Codable {
    let events: [Event]
}

// MARK: - Event
struct Event: Codable {
    let id: Int
    let datetimeUTC: String
    let venue: Venue
    let performers: [Performer]
    let shortTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case datetimeUTC = "datetime_utc"
        case venue, performers
        case shortTitle = "short_title"
    }
}

// MARK: - Performer
struct Performer: Codable {
    let name: String
    let image: String
    let id: Int
}

// MARK: - Venue
struct Venue: Codable {
    let name, displayLocation: String

    enum CodingKeys: String, CodingKey {
        case name
        case displayLocation = "display_location"
    }
}
