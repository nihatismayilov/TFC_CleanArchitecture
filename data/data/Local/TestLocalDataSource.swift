//
//  CardLocalDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
//import RealmSwift
import Combine

//class TestLocalDataSource: TestLocalDataSourceProtocol {
//    
////    private let realmClient: RealmClientProtocol
//
//    private let cardsSubject: CurrentValueSubject<[TestLocalDTO], Never> = .init([])
//    
//    init(/*realmClient: RealmClientProtocol*/) {
////        self.realmClient = realmClient
//        Task {
//            await self.syncCards()
//        }
//    }
//    
//    private func syncCards() async {
////        self.cardsSubject.send(await self.realmClient.read().freeze())
//    }
//    
//    func observeCards() -> AnyPublisher<[TestLocalDTO], Never> {
//        return self.cardsSubject.eraseToAnyPublisher()
//    }
//    
//    func save(cards: [TestLocalDTO]) async throws {
////        try await self.realmClient.replace(objects: cards)
//        await self.syncCards()
//    }
//}
