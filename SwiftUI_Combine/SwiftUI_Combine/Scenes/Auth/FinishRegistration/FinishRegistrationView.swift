//
//  FinishRegistrationView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 21.10.2022.
//

import SwiftUI

// MARK: - Constants

private struct Constants {
    static let backButton: String = "Back"
}

struct FinishRegistrationView: View {

    // MARK: - Properties

    @StateObject var viewModel: FinishRegistrationViewModel

    @Binding var shouldReturnToRoot: Bool

    // MARK: - View

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.textLabel)
                .font(Font.system(size: 16))
                .bold()
                .multilineTextAlignment(.center)

            Button(action: { shouldReturnToRoot.toggle() }) {
                Text(Constants.backButton)
                    .font(Font.system(size: 16))
                    .bold()
                    .tint(Color.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
}

// MARK: - PreviewProvider

struct FinishRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistrationView(viewModel: FinishRegistrationViewModel(input: FinishRegistrationModuleInput(email: "test@mail.com", name: "Vlad")),
                               shouldReturnToRoot: .constant(true))
    }
}
