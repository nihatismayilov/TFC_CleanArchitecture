//
//  RegisterRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Alamofire

class RegisterRemoteDataSource: RegisterRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func register(by phoneNumber: String) async throws -> Bool {
        try await dispatcher.request(
            baseUrl: .b2cBaseURL,
            endpoint: RegisterAPI.register.endpoint,
            method: .post,
            headers: .default,
            params: RegisterRequestModel(phoneNumber: phoneNumber),
            encoder: URLEncodedFormParameterEncoder.default
        )!
    }
}
