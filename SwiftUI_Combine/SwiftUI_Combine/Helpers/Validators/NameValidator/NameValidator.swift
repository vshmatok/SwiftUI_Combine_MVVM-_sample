//
//  NameValidator.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation

struct NameValidatorImpl: BaseValidator {
    func validate(_ object: String?) -> ValidationResult {
        guard let trimmedString = object?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .error(NameValidatorError.emptyName)
        }

        guard trimmedString.count > 2 else { return .error(NameValidatorError.notValidName) }

        return .success
    }
}
