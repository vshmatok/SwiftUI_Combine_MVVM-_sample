//
//  RegistrationInputItemViewModel.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 13.10.2022.
//

import Foundation
import Combine
import SwiftUI
import CombineExt

class RegistrationInputItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var text: String = ""
    @Published var errorMessage: String? = nil
    @Published var isActive: Bool = false

    var mainErrorMessage = CurrentValueSubject<String?, Never>(nil)
    var additionalErrorMessage = CurrentValueSubject<String?, Never>(nil)

    var onSubmit: PassthroughSubject<RegistrationCellKind?, Never>

    private var cancellables = Set<AnyCancellable>()

    var kind: RegistrationCellKind
    var validator: BaseValidator

    // MARK: - Init

    init(kind: RegistrationCellKind,
         validator: BaseValidator,
         onSubmit: PassthroughSubject<RegistrationCellKind?, Never>,
         text: String = "") {
        self.kind = kind
        self.validator = validator
        self.onSubmit = onSubmit
        self.text = text

        prepareSubjects()
    }

    // MARK: - Private

    private func prepareSubjects() {
        let isTextFieldActive = $isActive
            .removeDuplicates()

        isTextFieldActive
            .dropFirst()
            .filter({ !$0 })
            .withLatestFrom($text)
            .map { [weak self] text -> String? in
                let textValidation = self?.validator.validate(text)
                return textValidation?.errorMessage
            }
            .assign(to: \.value, on: mainErrorMessage)
            .store(in: &cancellables)

        isTextFieldActive
            .filter({ $0 })
            .map({ _ in nil })
            .assign(to: \.value, on: mainErrorMessage)
            .store(in: &cancellables)

        isTextFieldActive
            .filter({ $0 })
            .map({ _ in nil })
            .assign(to: \.value, on: additionalErrorMessage)
            .store(in: &cancellables)

        Publishers.CombineLatest(mainErrorMessage, additionalErrorMessage)
            .map({ $0.0 ?? $0.1 })
            .assign(to: &$errorMessage)
    }
}

// MARK: - Identifiable

extension RegistrationInputItemViewModel: Identifiable {
    var id: Int {
        return kind.hashValue
    }
}
