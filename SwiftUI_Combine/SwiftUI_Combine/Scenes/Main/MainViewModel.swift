//
//  MainViewModel.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 21.10.2022.
//

import Foundation

final class MainViewModel: ObservableObject {

    // MARK: - Properties

    @Published var name: String = ""

    private var userService: UserService

    // MARK: - Initialization

    init(userService: UserService = UserServiceImpl.instance) {
        self.userService = userService
        
        prepareSubjects()
    }

    // MARK: - Public

    func onLogout() {
        userService.removeActiveUser()
    }

    // MARK: - Private

    private func prepareSubjects() {
        userService.activeUser
            .map({ $0?.name ?? "Unknown" })
            .assign(to: &$name)
    }
}
