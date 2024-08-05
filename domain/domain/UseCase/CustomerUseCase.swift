//
//  CustomerUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine

protocol CustomerUseCaseProtocol {
    func getProfile() -> AnyPublisher<Bool, Error>
}

public class CustomerUseCase: CustomerUseCaseProtocol {
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func getProfile() -> AnyPublisher<Bool, any Error> {
        return repo.getProfile()
    }
}
