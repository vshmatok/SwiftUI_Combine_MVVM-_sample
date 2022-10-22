//
//  RegistrationViewModel.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 13.10.2022.
//

import Foundation
import SwiftUI
import Combine
import CombineExt

class RegistrationViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: - Input

    private var onSubmit = PassthroughSubject<RegistrationCellKind?, Never>()

    // MARK: - Output

    var dataSource: [RegistrationInputItemViewModel] = []

    @Published var isLoading: Bool = false
    @Published var isRegistrationEnabled: Bool = false
    @Published var registrationErrorMessage: String?
    @Published var finishRegistrationModuleInput: FinishRegistrationModuleInput?

    private var emailValidator: BaseValidator
    private var passwordValidator: BaseValidator
    private var nameValidator: BaseValidator
    private var authorizationService: AuthorizationService

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(input: RegistrationModuleInput,
         emailValidator: BaseValidator = EmailValidatorImpl(),
         passwordValidator: BaseValidator = PasswordValidatorImpl(),
         nameValidator: BaseValidator = NameValidatorImpl(),
         authorizationService: AuthorizationService = AuthorizationServiceImpl()) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.nameValidator = nameValidator
        self.authorizationService = authorizationService

        self.dataSource = [RegistrationInputItemViewModel(kind: .email,
                                                          validator: emailValidator,
                                                          onSubmit: self.onSubmit,
                                                          text: input.email),
                           RegistrationInputItemViewModel(kind: .password,
                                                          validator: passwordValidator,
                                                          onSubmit: self.onSubmit),
                           RegistrationInputItemViewModel(kind: .repeatPassword,
                                                          validator: passwordValidator,
                                                          onSubmit: self.onSubmit),
                           RegistrationInputItemViewModel(kind: .name,
                                                          validator: nameValidator,
                                                          onSubmit: self.onSubmit)]

        prepareSubjects()
    }

    // MARK: - Public

    func onTapAuthorization() {
        if  let emailViewModel = dataSource.first(where: { $0.kind == .email }),
            let passwordViewModel = dataSource.first(where: { $0.kind == .password }),
            let nameViewModel = dataSource.first(where: { $0.kind == .name }) {

            isLoading = true

            Publishers.CombineLatest3(emailViewModel.$text,
                                      passwordViewModel.$text,
                                      nameViewModel.$text)
            .flatMap { [weak self] (email, password, name) -> AnyPublisher<(String, String), Error> in
                guard let self else {
                    return Fail<(String, String), Error>(error: GenericError.missingSelf)
                        .eraseToAnyPublisher()
                }
                return self.authorizationService.register(email: email, name: name, password: password)
                    .delay(for: .seconds(2), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.registrationErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (email, name) in
                self?.isLoading = false
                self?.finishRegistrationModuleInput = FinishRegistrationModuleInput(email: email, name: name)
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - Private

    private func prepareSubjects() {
        onSubmit
            .sink { [weak self] kind in
                guard let kind else { return }

                switch kind {
                case .email:
                    self?.dataSource.forEach({ $0.isActive = false })
                    self?.dataSource.first(where: { $0.kind == .password })?.isActive = true
                case .password:
                    self?.dataSource.forEach({ $0.isActive = false })
                    self?.dataSource.first(where: { $0.kind == .repeatPassword })?.isActive = true
                case .repeatPassword:
                    self?.dataSource.forEach({ $0.isActive = false })
                    self?.dataSource.first(where: { $0.kind == .name })?.isActive = true
                case .name:
                    self?.dataSource.forEach({ $0.isActive = false })
                }
            }
            .store(in: &cancellables)

        if let emailViewModel = dataSource.first(where: { $0.kind == .email }),
           let passwordViewModel = dataSource.first(where: { $0.kind == .password }),
           let repeatPasswordViewModel = dataSource.first(where: { $0.kind == .repeatPassword }),
           let nameViewModel = dataSource.first(where: { $0.kind == .name }) {

            let isPasswordInputValid = Publishers.CombineLatest3(passwordViewModel.$text,
                                                                 passwordViewModel.$errorMessage,
                                                                 passwordViewModel.$isActive)
                .map({ !$0.0.isEmpty && $0.1 == nil && $0.2 == false })

            let isRepeatPasswordInputValid = Publishers.CombineLatest3(repeatPasswordViewModel.$text,
                                                                       repeatPasswordViewModel.$errorMessage,
                                                                       repeatPasswordViewModel.$isActive)
                .map({ !$0.0.isEmpty && $0.1 == nil && $0.2 == false })

            let shouldFieldsBeValidated = Publishers.CombineLatest(isPasswordInputValid, isRepeatPasswordInputValid)
                .map({ $0.0 == true && $0.1 == true })

            let repeatPasswordExternalValidation = Publishers.CombineLatest(passwordViewModel.$text,
                                                                            repeatPasswordViewModel.$text)
                .map ({ $0.0 == $0.1 ? nil : "Passwords doesn't match" })

            shouldFieldsBeValidated
                .filter({ $0 == true })
                .withLatestFrom(repeatPasswordExternalValidation)
                .assign(to: \.value, on: repeatPasswordViewModel.additionalErrorMessage)
                .store(in: &cancellables)

            shouldFieldsBeValidated
                .filter({ $0 == false })
                .map({ _ in nil })
                .assign(to: \.value, on: repeatPasswordViewModel.additionalErrorMessage)
                .store(in: &cancellables)

            let hasActiveViews = dataSource.map({ $0.$isActive })
                .combineLatest()
                .map({ $0.contains(where: { $0 == true }) })

            let dataIsValid = Publishers.CombineLatest4(emailViewModel.$text,
                                                        nameViewModel.$text,
                                                        passwordViewModel.$text,
                                                        repeatPasswordViewModel.$text)
                .map({ [weak self] (email, name, password, repeatPassword) -> Bool in
                    guard let self = self else { return false }

                    let emailValidation = self.emailValidator.validate(email)
                    let passwordValidation = self.passwordValidator.validate(password)
                    let repeatPasswordValidation = self.passwordValidator.validate(repeatPassword)
                    let nameValidation = self.nameValidator.validate(name)

                    return emailValidation.isValid
                    && nameValidation.isValid
                    && passwordValidation.isValid
                    && repeatPasswordValidation.isValid
                    && password == repeatPassword
                })

            Publishers.CombineLatest(hasActiveViews, dataIsValid)
                .map({ $0.0 == false && $0.1 == true })
                .assign(to: &$isRegistrationEnabled)
        }
    }
}
