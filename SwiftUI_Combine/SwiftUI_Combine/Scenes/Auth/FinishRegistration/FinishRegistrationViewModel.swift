//
//  FinishRegistrationViewModel.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 21.10.2022.
//

import Combine
import SwiftUI

final class FinishRegistrationViewModel: ObservableObject {

    // MARK: - Properties

    @Published var textLabel: String

    // MARK: - Initialization

    init(input: FinishRegistrationModuleInput) {
        textLabel = "Thanks \(input.name).\nTo finish registration go to \(input.email)"
    }
}
