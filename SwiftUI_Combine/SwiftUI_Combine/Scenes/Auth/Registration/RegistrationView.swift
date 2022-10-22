//
//  RegistrationView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 11.10.2022.
//

import SwiftUI

// MARK: - Constants

private struct Constants {
    static let navigationBarTitle = "Registration"
    static let registrationButtonText = "Register"
    static let errorAlertTitle: String = "Registration error"
    static let errorActionButtonTitle: String = "OK"
}

// MARK: - FocusedTextField

enum RegistrationViewFocusedTextField {
    case email
    case password
    case repeatPassword
    case name
}

struct RegistrationView: View {

    // MARK: - Properties

    @StateObject var viewModel: RegistrationViewModel

    @Binding var shouldReturnToRoot: Bool

    // MARK: - View

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.dataSource) { itemViewModel in
                        RegistrationInputItem(viewModel: itemViewModel, configuration: itemViewModel.kind.configuration)
                    }
                }
            }

            createFooterActionButtonsView()
                .padding(8)

            createNavigationFinishRegistrationNavigationLink()
        }
        .alert(Constants.errorAlertTitle,
               isPresented: .constant(viewModel.registrationErrorMessage != nil),
               actions: {
            Button(Constants.errorActionButtonTitle) {
                viewModel.registrationErrorMessage = nil
            }
        }, message: {
            Text(viewModel.registrationErrorMessage ?? "")
        })
        .padding(.horizontal, 16.0)
        .navigationTitle(Constants.navigationBarTitle)
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
                    Button(action: viewModel.onTapAuthorization) {
                        Text(Constants.registrationButtonText)
                            .foregroundColor(.white)
                            .font(Font.system(size: 16))
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color.blue)
                            .cornerRadius(4)
                    }
                    .disabled(!viewModel.isRegistrationEnabled)
                    .opacity(viewModel.isRegistrationEnabled ? 1 : 0.5)
                }
            }
        }
    }

    private func createNavigationFinishRegistrationNavigationLink() -> some View {
        NavigationLink(
            isActive: .constant(viewModel.finishRegistrationModuleInput != nil),
            destination: {
                guard let finishRegistrationInput = viewModel.finishRegistrationModuleInput else { return AnyView(EmptyView()) }

                let viewModel = FinishRegistrationViewModel(input: finishRegistrationInput)
                return AnyView(FinishRegistrationView(viewModel: viewModel, shouldReturnToRoot: $shouldReturnToRoot))
            }, label: {
                EmptyView()
            })
    }
}

// MARK: - PreviewProvider

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel(input: RegistrationModuleInput(email: "test@mail.com")),
                         shouldReturnToRoot: .constant(true))
    }
}

