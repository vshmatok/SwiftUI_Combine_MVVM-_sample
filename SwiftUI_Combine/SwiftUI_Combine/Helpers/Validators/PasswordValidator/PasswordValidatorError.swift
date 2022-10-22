//
//  PasswordValidatorError.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import Foundation

enum PasswordValidatorError: LocalizedError {

    // MARK: - Cases

    case emptyPassword
    case notValidPassword

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .emptyPassword:
            return "Password can't be empty or contain only whitespaces and newlines"
        case .notValidPassword:
            return "Password is not valid"
        }
    }
}
