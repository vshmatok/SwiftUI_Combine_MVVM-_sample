//
//  MainView.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 21.10.2022.
//

import SwiftUI

// MARK: - Constants

private struct Constants {
    static let navigationBarTitle = "Profile"
    static let nameLabelPrefix: String = "Name: "
    static let logoutButtonText: String = "Logout"
}

struct MainView: View {

    // MARK: - Properties

    @StateObject var viewModel: MainViewModel

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Text("\(Constants.nameLabelPrefix)\(viewModel.name)")
                    .font(Font.system(size: 16))
                    .bold()
                    .multilineTextAlignment(.center)

                Button(action: viewModel.onLogout) {
                    Text(Constants.logoutButtonText)
                        .font(Font.system(size: 16))
                        .bold()
                        .tint(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.blue)
                .cornerRadius(4)
            }
            .padding(.horizontal)
            .navigationTitle(Constants.navigationBarTitle)
        }
    }
}

// MARK: - PreviewProvider

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
