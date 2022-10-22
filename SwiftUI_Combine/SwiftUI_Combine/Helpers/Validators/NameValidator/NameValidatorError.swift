//
//  NameValidatorError.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import Foundation

enum NameValidatorError: LocalizedError {

    // MARK: - Cases

    case emptyName
    case notValidName

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name can't be empty or contain only whitespaces and newlines"
        case .notValidName:
            return "Name is not valid"
        }
    }
}
