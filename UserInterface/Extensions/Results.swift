//
//  Results.swift
//  UserInterface
//
//  Created by Ilya on 08.04.2021.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
