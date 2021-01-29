//
//  Event_FinderTests.swift
//  Event FinderTests
//
//  Created by Matvey Kostukovsky on 1/23/21.
//

import XCTest
@testable import Event_Finder

class NetworkTests: XCTestCase {
    
    func testAPICall() {
        let exp = expectation(description: "download data from SeatGeek API")
        
        guard let url = URL(string: "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    // success: convert the data to a string and send it back
                    let stringData = String(decoding: data, as: UTF8.self)
                    let rawResponse: RawResponse = try! JSONDecoder().decode(RawResponse.self, from: stringData.data(using: .utf8)!)
                    
                    Events.allEvents = rawResponse.events
                    
                    XCTAssert(Events.allEvents.count > 0)
                    exp.fulfill()
                }

        }.resume()
        
        wait(for: [exp], timeout: 10.0)
    }
    
}

class FavoriteEventTests: XCTestCase {
    
    func testAddingEventToFavorites() {
        let unlikelyEventID = -1
        Events.addEventToFavorites(eventID: unlikelyEventID)
        
        XCTAssertTrue(Events.isEventFavorite(unlikelyEventID))
        
        Events.removeEventFromFavorites(eventID: unlikelyEventID)
    }
    
    func testRemovingEventFromFavorites() {
        let unlikelyEventID = -1
        Events.addEventToFavorites(eventID: unlikelyEventID)
        Events.removeEventFromFavorites(eventID: unlikelyEventID)
        XCTAssertFalse(Events.isEventFavorite(unlikelyEventID))
    }
    
}
