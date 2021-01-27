//
//  API.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/25/21.
//

import Foundation

extension ViewController {
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // check the URL is good, otherwise return failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    let stringData = String(decoding: data, as: UTF8.self)
                    let rawResponse: RawResponse = try! JSONDecoder().decode(RawResponse.self, from: stringData.data(using: .utf8)!)
                    
                    Events.allEvents = rawResponse.events
                    
                    completion(.success("yay"))
                } else if error != nil {
                    // some kind of a network failure
                    completion(.failure(.requestFailed))
                } else {
                    // unknown error
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
    
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
