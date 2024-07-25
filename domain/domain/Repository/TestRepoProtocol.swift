//
//  TestRepoProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine

public protocol TestRepoProtocol {
    func syncTestData() async throws
    func observeTestData() -> AnyPublisher<[Test], Never>
}
