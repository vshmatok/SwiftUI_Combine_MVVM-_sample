//
//  BaseValidator.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation

protocol BaseValidator {
    func validate(_ object: String?) -> ValidationResult
}
