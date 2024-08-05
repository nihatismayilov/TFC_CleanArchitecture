//
//  RegisterRepoProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine

public protocol RegisterRepoProtocol {
    func register(by phoneNumber: String) -> AnyPublisher<Bool, any Error>
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<Token, any Error>
}
