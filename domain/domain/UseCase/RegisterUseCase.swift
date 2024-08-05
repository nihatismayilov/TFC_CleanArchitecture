//
//  RegisterUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine

protocol RegisterUseCaseProtocol {
    func register(by phoneNumber: String) -> AnyPublisher<Bool, any Error>
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<Token, any Error>
}

public class RegisterUseCase: /*BaseAsyncThrowsUseCase*/ RegisterUseCaseProtocol {
    private let repo: RegisterRepoProtocol
    
    init(repo: RegisterRepoProtocol) {
        self.repo = repo
    }
    
//    public func execute(input: String) -> AnyPublisher<Bool, any Error> {
//        return repo.register(by: input)
//    }
    
    public func register(by phoneNumber: String) -> AnyPublisher<Bool, any Error> {
        return repo.register(by: phoneNumber)
    }
    
    public func token(by phoneNumber: String, otp: String) -> AnyPublisher<Token, any Error> {
        return repo.token(by: phoneNumber, otp: otp)
    }
}
