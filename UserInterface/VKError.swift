//
//  VKError.swift
//  UserInterface
//
//  Created by Ilya on 18.05.2021.
//

import Foundation

enum VKError: Error {
    case needValidation(message: String)
    case cannotDeserialize(message: String)
    case dataIsEmpty(message: String)
}

extension VKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotDeserialize(let message):
            return NSLocalizedString(message, comment: "")
        case .needValidation(message: let message):
            return NSLocalizedString(message, comment: "")
        case .dataIsEmpty(message: let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
