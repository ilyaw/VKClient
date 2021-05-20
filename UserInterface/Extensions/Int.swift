//
//  Int.swift
//  UserInterface
//
//  Created by Ilya on 08.05.2021.
//

import Foundation

extension Int {
    func toDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timeInterval = TimeInterval(self)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)

        dateFormatter.locale = Locale(identifier: "ru_RU")

        return dateFormatter.string(from: myNSDate)
    }
}
