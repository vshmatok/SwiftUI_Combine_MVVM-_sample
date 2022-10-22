//
//  MainContainerView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 22.10.2022.
//

import SwiftUI

struct MainContainerView: View {

    // MARK: - Properties

    @State private var user: User?

    // MARK: - View

    var body: some View {
        Group {
            if user != nil {
                MainView(viewModel: MainViewModel())
            } else {
                LoginView(viewModel: LoginViewModel())
            }
        }
        .onReceive(UserServiceImpl.instance.activeUser) { user in
            withAnimation {
                self.user = user
            }
        }
    }
}
