//
//  LoginViewModel.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 11.10.2022.
//

import Foundation
import Combine
import CombineExt

final class LoginViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: - Input

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEmailViewActive: Bool = false
    @Published var isPasswordViewActive: Bool = false

    // MARK: - Output

    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isAuthorizationEnabled: Bool = false
    @Published var authorizationErrorMessage: String?

    private var emailValidator: BaseValidator
    private var passwordValidator: BaseValidator
    private var authorizationService: AuthorizationService
    private var userService: UserService

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(emailValidator: BaseValidator = EmailValidatorImpl(),
         passwordValidator: BaseValidator = PasswordValidatorImpl(),
         authorizationService: AuthorizationService = AuthorizationServiceImpl(),
         userService: UserService = UserServiceImpl.instance) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.authorizationService = authorizationService
        self.userService = userService

        prepareSubjects()
    }

    // MARK: - Public

    func onSubmitLogin() {
        isLoading = true

        authorizationService.authorize(email: email, password: password)
            .delay(for: 2, scheduler: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.authorizationErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.userService.save(user: user)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private

    private func prepareSubjects() {
        let isEmailTextFieldActive = $isEmailViewActive
            .removeDuplicates()
            .dropFirst()

        isEmailTextFieldActive
            .filter({ !$0 })
            .withLatestFrom($email)
            .map { [weak self] email -> String? in
                let emailValidation = self?.emailValidator.validate(email)
                return emailValidation?.errorMessage
            }
            .assign(to: &$emailErrorMessage)

        isEmailTextFieldActive
            .filter({ $0 })
            .map({ _ in nil })
            .assign(to: &$emailErrorMessage)

        let isPasswordTextFieldActive = $isPasswordViewActive
            .removeDuplicates()
            .dropFirst()

        isPasswordTextFieldActive
            .filter({ !$0 })
            .withLatestFrom($password)
            .map { [weak self] password -> String? in
                let passwordValidation = self?.passwordValidator.validate(password)
                return passwordValidation?.errorMessage
            }
            .assign(to: &$passwordErrorMessage)

        isPasswordTextFieldActive
            .filter({ $0 })
            .map({ _ in nil })
            .assign(to: &$passwordErrorMessage)

        var credentials: AnyPublisher<(String?, String?), Never> {
            return Publishers.CombineLatest($email, $password)
                .map ({ email, password in
                    return (email, password)
                })
                .eraseToAnyPublisher()
        }

        let isValidCredentials = credentials
            .map({ [weak self] (email, password) -> Bool in
                guard let self = self else { return true }

                let emailValidation = self.emailValidator.validate(email)
                let passwordValidation = self.passwordValidator.validate(password)

                return emailValidation.isValid && passwordValidation.isValid
            })

        Publishers.CombineLatest4(isValidCredentials,
                                  isEmailTextFieldActive,
                                  isPasswordTextFieldActive,
                                  $isLoading)
        .map ({ isValidCredentials, isEmailTextFieldActive, isPasswordTextFieldActive, isLoading in
            return isValidCredentials && !isEmailTextFieldActive && !isPasswordTextFieldActive && !isLoading
        })
        .removeDuplicates()
        .assign(to: &$isAuthorizationEnabled)
    }
}
