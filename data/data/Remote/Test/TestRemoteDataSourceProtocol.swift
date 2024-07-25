//
//  TestRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

protocol TestRemoteDataSourceProtocol {
    func getCards(by customerId: String) async throws -> [TestRemoteDTO]
}
