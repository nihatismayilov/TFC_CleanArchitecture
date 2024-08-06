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
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
    init(
        remoteDataSourceProtocol: RegisterRemoteDataSourceProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol
    ) {
        self.remoteDataSourceProtocol = remoteDataSourceProtocol
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func register(by phoneNumber: String) -> AnyPublisher<Bool, any Error> {
        return remoteDataSourceProtocol.register(by: phoneNumber)
    }
    
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<Token, any Error> {
        return remoteDataSourceProtocol.token(by: phoneNumber, otp: otp)
            .receive(on: DispatchQueue.main)
            .map { [weak self] data in
                guard let self,
                      let token = data.token,
                      let checkToken = data.checkToken,
                      let refreshToken = data.refreshToken else {
                    return data.toDomain()
                }
                userDefaultsStorage.cache(key: .token, value: token)
                userDefaultsStorage.cache(key: .checkToken, value: checkToken)
                userDefaultsStorage.cache(key: .refreshToken, value: refreshToken)
                return data.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
