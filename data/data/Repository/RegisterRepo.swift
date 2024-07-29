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
    
    func register(by phoneNumber: String) async throws -> Bool {
        try await remoteDataSourceProtocol.register(by: phoneNumber)
    }
}
