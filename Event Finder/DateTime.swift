//
//  DateTime.swift
//  Event Finder
//
//  Created by Matvey Kostukovsky on 1/30/21.
//

import UIKit

struct DateTime {
    static func getDate(from dateTimeString: String) -> String? {
        let dateFormatter = DateTime.getDateFormatterForIncomingDates()
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, dd MMM YYYY"
        
        return dateFormatter.string(from: date)
    }
    
    static func getLocalTime(from dateTimeString: String) -> String? {
        let dateFormatter = DateTime.getDateFormatterForIncomingDates()
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date)
    }
    
    static func getLocalDateTime(from dateTimeString: String) -> String? {
        let dateFormatter = DateTime.getDateFormatterForIncomingDates()
        guard let date = dateFormatter.date(from: dateTimeString) else { return nil }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, dd MMM YYYY @ h:mm a"
        
        return dateFormatter.string(from: date)
    }
    
    static private func getDateFormatterForIncomingDates() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter
    }
}


extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
