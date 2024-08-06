//
//  CustomerUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine

protocol CustomerUseCaseProtocol {
    func getProfile() -> AnyPublisher<Profile, Error>
}

public class CustomerUseCase: CustomerUseCaseProtocol {
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func getProfile() -> AnyPublisher<Profile, any Error> {
        return repo.getProfile()
    }
}
