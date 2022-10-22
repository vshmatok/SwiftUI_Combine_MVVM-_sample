//
//  UserService.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation
import Combine
import CombineExt

// MARK: - Protocols

protocol UserService: AnyObject {
    var activeUser: AnyPublisher<User?, Never> { get }

    func save(user: User)
    func removeActiveUser()
}

final class UserServiceImpl: UserService {

    // MARK: - Constants

    private struct Constants {
        static let userKey: String = "savedUser"
    }

    // MARK: - Properties

    static let instance: UserService = UserServiceImpl()

    private var userDefaults: UserDefaults

    private var userSubject = CurrentValueSubject<User?, Never>(nil)
    var activeUser: AnyPublisher<User?, Never> { return userSubject.share(replay: 1).eraseToAnyPublisher() }

    // MARK: - Initialization

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        setActiveUser()
    }

    // MARK: - UserService

    func save(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            userDefaults.set(encoded, forKey: Constants.userKey)
            userSubject.send(user)
        }
    }

    func removeActiveUser() {
        userDefaults.removeObject(forKey: Constants.userKey)
        userSubject.send(nil)
    }

    // MARK: - Private

    private func setActiveUser() {
        guard let savedUser = userDefaults.object(forKey: Constants.userKey) as? Data,
              let user = try? JSONDecoder().decode(User.self, from: savedUser) else {
                  return
              }

        userSubject.send(user)
    }
}
