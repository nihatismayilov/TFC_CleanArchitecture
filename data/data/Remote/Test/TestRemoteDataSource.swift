//
//  TestRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Alamofire

class TestRemoteDataSource: TestRemoteDataSourceProtocol {
    
    private let networkClient: Dispatcher
    
    init(networkClient: Dispatcher) {
        self.networkClient = networkClient
    }
    
    func getCards(by customerId: String) async throws -> [TestRemoteDTO] {
        try await self.networkClient.request(
            baseUrl: TestAPI.getCards(customerId).baseUrl,
            endpoint: TestAPI.getCards(customerId).endpoint,
            method: .get,
            headers: .default,
            params: EmptyParams(),
            encoder: URLEncodedFormParameterEncoder.default
        )
    }
}
