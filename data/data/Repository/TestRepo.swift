//
//  TestRepo.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine
import domain

class TestRepo: TestRepoProtocol {
    private let localDataSource: TestLocalDataSourceProtocol
    private let remoteDataSource: TestRemoteDataSourceProtocol
    
    init(
        localDataSource: TestLocalDataSourceProtocol,
        remoteDataSource: TestRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func syncTestData() async throws {
        let card = try await self.remoteDataSource.getCards(
            by: "customer_id" //customerLocalDataSource.getCustomerID()
        ).map { $0.toLocal() }
        
        try await self.localDataSource.save(cards: card)
    }
    
    func observeTestData() -> AnyPublisher<[Test], Never> {
        return self.localDataSource.observeCards()
            .receive(on: DispatchQueue.main)
            .map { localData in
                return localData.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}
