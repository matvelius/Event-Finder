//
//  Events.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/24/21.
//

import UIKit

struct Events {
    static var allEvents = [Event]()
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
