//
//  RegistrationCellKind.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import Foundation

enum RegistrationCellKind: CaseIterable {

    // MARK: - Cases

    case email
    case password
    case repeatPassword
    case name

    // MARK: - Properties

    var configuration: UserInputViewUIConfiguration {
        switch self {
        case .email:
            return UserInputViewUIConfiguration(title: "Email",
                                                textFieldPlaceholder: "Enter your email address...",
                                                shouldShowSecureSwitchButton: false,
                                                submitLabel: .next,
                                                keyboardType: .emailAddress)
        case .password:
            return UserInputViewUIConfiguration(title: "Password",
                                                textFieldPlaceholder: "Enter your password...",
                                                shouldShowSecureSwitchButton: true,
                                                submitLabel: .next,
                                                keyboardType: .default)
        case .repeatPassword:
            return UserInputViewUIConfiguration(title: "Repeat password",
                                                textFieldPlaceholder: "Repeat your password...",
                                                shouldShowSecureSwitchButton: true,
                                                submitLabel: .next,
                                                keyboardType: .default)
        case .name:
            return UserInputViewUIConfiguration(title: "Name",
                                                textFieldPlaceholder: "Enter your name...",
                                                shouldShowSecureSwitchButton: false,
                                                submitLabel: .go,
                                                keyboardType: .default)
        }
    }
}
