//
//  API.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/25/21.
//

import UIKit

extension EventsListVC {
    
    func fetchData(query: String?, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        var urlString = ""
        
        if query != nil && query != "" {
            urlString =  "https://api.seatgeek.com/2/events?q=\(query!)&client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)"
        } else {
            urlString = "https://api.seatgeek.com/2/events?client_id=\(Secrets.CLIENT_ID)&client_secret=\(Secrets.CLIENT_SECRET)"
        }
        
        
        // check the URL is good, otherwise return failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        let urlConfig = URLSessionConfiguration.default
        urlConfig.timeoutIntervalForRequest = 7

        URLSession(configuration: urlConfig).dataTask(with: url) { data, response, error in

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.showAlert(with: "There seems to be an issue with your URL or the server. Please contact the app creators.")
                return
            }
            
            if let data = data {
                // success: convert the data to a string and send it back
                let stringData = String(decoding: data, as: UTF8.self)
                if let rawResponse: RawResponse = try? JSONDecoder().decode(RawResponse.self, from: stringData.data(using: .utf8)!) {
                    if query != nil && query != "" {
                        Events.searchedEvents = rawResponse.events
                    } else {
                        Events.allEvents = rawResponse.events
                    }
                    
                    completion(.success("success"))
                } else {
                    completion(.failure(.unknown))
                }
                
                
            } else if error != nil {
                // some kind of a network failure
                completion(.failure(.requestFailed))
                self.showAlert(with: "Network request failed. Please check your connection and try again.")
            } else {
                // unknown error
                completion(.failure(.unknown))
                self.showAlert(with: "Uknown error.")
            }

        }.resume()
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
