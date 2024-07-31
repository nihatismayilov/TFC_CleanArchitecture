//
//  RegisterRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Alamofire
import Combine

class RegisterRemoteDataSource: RegisterRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func register(by phoneNumber: String) -> AnyPublisher<Bool, Error> {
        let request = RegisterRequest.register(params: ["phoneNumber": phoneNumber])
        return dispatcher.execute(for: request)
    }
    
    func token(by phoneNumber: String, otp: String) -> AnyPublisher<TokenRemoteDTO, Error> {
        let parameters = ["phoneNumber": phoneNumber, "otp": otp]
        let request = RegisterRequest.token(params: parameters)
        
        return dispatcher.execute(for: request)
    }
}
