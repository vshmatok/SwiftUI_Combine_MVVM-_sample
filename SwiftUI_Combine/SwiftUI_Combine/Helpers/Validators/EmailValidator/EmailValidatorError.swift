//
//  EmailValidatorError.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import Foundation

enum EmailValidatorError: LocalizedError {

    // MARK: - Cases

    case emptyEmail
    case notValidEmail

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Email can't be empty or contain only whitespaces and newlines"
        case .notValidEmail:
            return "Email is not valid"
        }
    }
}
