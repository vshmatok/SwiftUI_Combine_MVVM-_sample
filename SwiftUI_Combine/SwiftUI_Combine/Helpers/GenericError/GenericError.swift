//
//  GenericError.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 16.10.2022.
//

import Foundation

enum GenericError: LocalizedError {

    // MARK: - Cases

    case missingSelf
    case cancelled

    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .missingSelf:
            return "Something went wrong. Please try again"
        case .cancelled:
            return "Cancelled"
        }
    }
}
