//
//  CustomerRepo.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine
import domain

class CustomerRepo: CustomerRepoProtocol {
    private let remoteDataSourceProtocol: CustomerRemoteDataSourceProtocol
    
    init(
        remoteDataSourceProtocol: CustomerRemoteDataSourceProtocol
    ) {
        self.remoteDataSourceProtocol = remoteDataSourceProtocol
    }
    
    func getProfile() -> AnyPublisher<Bool, any Error> {
        return remoteDataSourceProtocol.getProfile()
    }
}
