//
//  RegisterRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine

protocol RegisterRemoteDataSourceProtocol {
    func register(by phoneNumber: String) -> AnyPublisher<Bool, Error>
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<TokenRemoteDTO, Error>
}
