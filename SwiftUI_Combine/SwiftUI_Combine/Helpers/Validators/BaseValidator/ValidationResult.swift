//
//  ValidationResult.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import Foundation

enum ValidationResult {

    // MARK: - Cases

    case success
    case error(LocalizedError)

    // MARK: - Properties

    var isValid: Bool {
        switch self {
        case .error:
            return false
        case .success:
            return true
        }
    }

    var errorMessage: String? {
        switch self {
        case .error(let error):
            return error.localizedDescription
        case .success:
            return nil
        }
    }
}
