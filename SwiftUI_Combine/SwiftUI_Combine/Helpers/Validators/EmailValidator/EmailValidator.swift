//
//  EmailValidator.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation

struct EmailValidatorImpl: BaseValidator {
    func validate(_ object: String?) -> ValidationResult {
        guard let trimmedString = object?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .error(EmailValidatorError.emptyEmail)
        }

        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")

        guard emailRegex.evaluate(with: trimmedString) else {
            return .error(EmailValidatorError.notValidEmail)
        }

        return .success
    }
}
