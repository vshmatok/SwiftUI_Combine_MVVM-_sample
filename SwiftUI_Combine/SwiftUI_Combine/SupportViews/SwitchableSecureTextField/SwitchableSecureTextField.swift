//
//  SwitchableSecureTextField.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 11.10.2022.
//

import SwiftUI

struct SwitchableSecureTextField: View {

    // MARK: - SwitchableSecureFocusField

    enum SwitchableSecureFocusField {
        case secure
        case unSecure
    }

    // MARK: - Properties

    @FocusState private var focusedTextField: SwitchableSecureFocusField?

    @State var isSecureTextEntry: Bool = false

    @Binding var text: String

    var configuration: SwitchableSecureTextFieldUIConfiguration

    // MARK: - View

    var body: some View {
        HStack {
            Group {
                if isSecureTextEntry {
                    SecureField(configuration.placeholder, text: $text)
                        .focused($focusedTextField, equals: .unSecure)
                } else {
                    TextField(configuration.placeholder, text: $text)
                        .focused($focusedTextField, equals: .secure)
                }
            }

            if configuration.shouldShowSecureSwitchButton {
                Button(action: {
                    isSecureTextEntry.toggle()

                    guard focusedTextField != nil else { return }
                    focusedTextField = focusedTextField == .secure ? .unSecure : .secure
                }, label: {
                    Image(systemName: !isSecureTextEntry ? "eye.slash" : "eye")
                        .foregroundColor(Color.gray)
                })
                .disabled(text.isEmpty)
            }
        }
    }
}
