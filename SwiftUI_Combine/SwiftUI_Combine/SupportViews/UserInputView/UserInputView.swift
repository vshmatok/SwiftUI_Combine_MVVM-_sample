//
//  UserInputView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 11.10.2022.
//

import SwiftUI

struct UserInputView: View {

    // MARK: - Properties

    var configuration: UserInputViewUIConfiguration

    @Binding var text: String
    @Binding var errorMessage: String?

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            Text(configuration.title)
                .font(Font.system(size: 20))
                .bold()
                .padding(.bottom, 8)

            SwitchableSecureTextField(text: $text,
                                      configuration: SwitchableSecureTextFieldUIConfiguration(placeholder: configuration.textFieldPlaceholder,
                                                                                              shouldShowSecureSwitchButton: configuration.shouldShowSecureSwitchButton))
            .submitLabel(configuration.submitLabel)
            .keyboardType(configuration.keyboardType)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(Font.system(size: 10))
                    .bold()
                    .foregroundColor(.red)
            }
        }
    }
}
