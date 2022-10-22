//
//  RegistrationInputItem.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 13.10.2022.
//

import Foundation
import SwiftUI

struct RegistrationInputItem: View {

    // MARK: - Properties

    @ObservedObject var viewModel: RegistrationInputItemViewModel

    @FocusState private var isActive: Bool

    var configuration: UserInputViewUIConfiguration

    // MARK: - View

    var body: some View {
        VStack {
            UserInputView(configuration: configuration,
                          text: $viewModel.text,
                          errorMessage: $viewModel.errorMessage)
            .focused($isActive)
            .onSubmit {
                viewModel.onSubmit.send(viewModel.kind)
            }
            .onChange(of: isActive)  {
                viewModel.isActive = $0
            }
            .onChange(of: viewModel.isActive) {
                isActive = $0
            }
        }
    }
}
