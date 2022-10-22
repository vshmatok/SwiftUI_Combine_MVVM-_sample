//
//  LoginView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 29.09.2022.
//

import SwiftUI

// MARK: - Constants

private struct Constants {
    static let navigationBarTitle = "Authorization"
    static let emailTextFieldPlaceholder: String = "Enter your email..."
    static let emailLabelText: String = "Email"
    static let passwordTextFieldPlaceholder: String = "Enter your password..."
    static let passwordLabelText: String = "Password"
    static let loginButtonText: String = "Login"
    static let registerButtonText: String = "Register"
    static let errorAlertTitle: String = "Authorization error"
    static let errorActionButtonTitle: String = "OK"
}

// MARK: - FocusedTextField

private enum FocusedTextField {
    case email
    case password
}

struct LoginView: View {

    // MARK: - Properties

    @StateObject var viewModel: LoginViewModel

    @State private var shouldReturnToRoot: Bool = false
    @FocusState private var focusedTextField: FocusedTextField?

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack {
                Group {
                    UserInputView(configuration: UserInputViewUIConfiguration(title: Constants.emailLabelText,
                                                                              textFieldPlaceholder: Constants.emailTextFieldPlaceholder,
                                                                              shouldShowSecureSwitchButton: false,
                                                                              submitLabel: .next,
                                                                              keyboardType: .emailAddress),
                                  text: $viewModel.email,
                                  errorMessage: $viewModel.emailErrorMessage)
                    .focused($focusedTextField, equals: .email)
                    .onSubmit {
                        focusedTextField = .password
                    }
                    .padding(.bottom, 12)

                    UserInputView(configuration: UserInputViewUIConfiguration(title: Constants.passwordLabelText,
                                                                              textFieldPlaceholder: Constants.passwordTextFieldPlaceholder,
                                                                              shouldShowSecureSwitchButton: true,
                                                                              submitLabel: .done,
                                                                              keyboardType: .alphabet),
                                  text: $viewModel.password,
                                  errorMessage: $viewModel.passwordErrorMessage)
                    .focused($focusedTextField, equals: .password)
                    .onSubmit {
                        focusedTextField = nil
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1)

                createFooterActionButtonsView()
            }
            .alert(Constants.errorAlertTitle,
                   isPresented: .constant(viewModel.authorizationErrorMessage != nil),
                   actions: {
                Button(Constants.errorActionButtonTitle) {
                    viewModel.authorizationErrorMessage = nil
                }
            }, message: {
                Text(viewModel.authorizationErrorMessage ?? "")
            })
            .padding(.horizontal, 16.0)
            .navigationTitle(Constants.navigationBarTitle)
            .onChange(of: focusedTextField) { focusedTextField in
                viewModel.isEmailViewActive = focusedTextField == .email
                viewModel.isPasswordViewActive = focusedTextField == .password
            }
        }
    }

    // MARK: - Private

    private func createFooterActionButtonsView() -> some View {
        VStack(spacing: 8) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                } else {
                    Button(action: viewModel.onSubmitLogin) {
                        Text(Constants.loginButtonText)
                            .foregroundColor(.white)
                            .font(Font.system(size: 16))
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color.blue)
                            .cornerRadius(4)
                    }
                    .disabled(!viewModel.isAuthorizationEnabled)
                    .opacity(viewModel.isAuthorizationEnabled ? 1 : 0.5)
                }
            }
            .padding(.top, 24)

            createRegistrationNavigationLink()
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1)
        }
    }

    private func createRegistrationNavigationLink() -> some View {
        let viewModel = RegistrationViewModel(input: RegistrationModuleInput(email: viewModel.email))
        let registrationView = RegistrationView(viewModel: viewModel, shouldReturnToRoot: $shouldReturnToRoot)

        return NavigationLink(destination: registrationView,
                              isActive: $shouldReturnToRoot) {
            Text(Constants.registerButtonText)
                .font(Font.system(size: 12))
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 40)
        }
    }
}

// MARK: - PreviewProvider

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
