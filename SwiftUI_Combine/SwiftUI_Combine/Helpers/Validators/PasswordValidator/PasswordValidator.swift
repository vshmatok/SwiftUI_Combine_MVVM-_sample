//
//  PasswordValidator.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation

struct PasswordValidatorImpl: BaseValidator {
    func validate(_ object: String?) -> ValidationResult {
        guard let trimmedString = object?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .error(PasswordValidatorError.emptyPassword)
        }

        guard trimmedString.count > 1 && trimmedString.count < 16 else {
            return .error(PasswordValidatorError.notValidPassword)
        }

        return .success
    }
}
