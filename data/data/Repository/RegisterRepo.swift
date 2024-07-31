//
//  RegisterRepo.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine
import domain

class RegisterRepo: RegisterRepoProtocol {
    private let remoteDataSourceProtocol: RegisterRemoteDataSourceProtocol
    
    init(
        remoteDataSourceProtocol: RegisterRemoteDataSourceProtocol
    ) {
        self.remoteDataSourceProtocol = remoteDataSourceProtocol
    }
    
    func register(by phoneNumber: String) -> AnyPublisher<Bool, any Error> {
        return remoteDataSourceProtocol.register(by: phoneNumber)
    }
    
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<Bool, any Error> {
        return remoteDataSourceProtocol.token(by: phoneNumber, otp: otp)
            .receive(on: DispatchQueue.main)
            .map { data in
                return data.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
