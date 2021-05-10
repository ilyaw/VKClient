//
//  Date.swift
//  UserInterface
//
//  Created by Ilya on 08.05.2021.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
//        let timeInterval = TimeInterval(23)
//        let myNSDate = Date(timeIntervalSince1970: timeInterval)

        dateFormatter.locale = Locale(identifier: "ru_RU")

        return dateFormatter.string(from: self)
        
    }
}
