//
//  CardLocalDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine

protocol TestLocalDataSourceProtocol {
    func observeCards() -> AnyPublisher<[TestLocalDTO], Never>
    func save(cards: [TestLocalDTO]) async throws
}
