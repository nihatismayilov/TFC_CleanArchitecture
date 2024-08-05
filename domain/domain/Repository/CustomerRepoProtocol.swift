//
//  CustomerRepositoryProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine

public protocol CustomerRepoProtocol {
    func getProfile() -> AnyPublisher<Bool, any Error>
}
