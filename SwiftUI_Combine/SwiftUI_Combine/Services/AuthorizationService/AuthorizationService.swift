//
//  AuthorizationService.swift
//  SwiftUI_Combine
//
//  Created by Vlad Shmatok on 06.10.2022.
//

import Foundation
import Combine

// MARK: - Protocols

protocol AuthorizationService: AnyObject {
    func authorize(email: String, password: String) -> Future<User, Error>
    func register(email: String, name: String, password: String) -> Future<(String, String), Error>
}

final class AuthorizationServiceImpl: AuthorizationService {

    // MARK: - Constants

    private struct Constants {
        static let predefinedEmail: String = "test@mail.com"
        static let predefinedPassword: String = "123456"

        static let predefinedUser: User = User(name: "Test")
    }

    // MARK: - AuthorizationService

    func authorize(email: String, password: String) -> Future<User, Error> {
        return Future<User, Error> { promise in
            guard email == Constants.predefinedEmail, password == Constants.predefinedPassword else {
               return promise(.failure(AuthorizationServiceError.wrongCredentials))
            }

            return promise(.success(Constants.predefinedUser))
        }
    }

    func register(email: String, name: String, password: String) -> Future<(String, String), Error> {
        return Future<(String, String), Error> { promise in
            if email == Constants.predefinedEmail {
                return promise(.failure(AuthorizationServiceError.emailIsTaken))
            }

            return promise(.success((email, name)))
        }
    }

}
