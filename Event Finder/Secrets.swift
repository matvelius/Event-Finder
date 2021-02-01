//
//  Secrets.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/26/21.
//

import Foundation

// I realize that it's a bad idea to include API keys and any sensitive data in code like this
// Best practice, if I understand correctly, is to keep this type of information server-side. I believe I should be able to delete this API key once you have a chance to take a look at the code.
struct Secrets {
    static let CLIENT_ID = "MjE1MTQ0OTJ8MTYxMTQ0NTQzNi4yMjc1Mzc5"
    static let CLIENT_SECRET = "71f4d249082a5c74c9a36a607acc29330a24f2869ff2dc5b248089ac54f9eca4"
    static let URL = "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)"
}
