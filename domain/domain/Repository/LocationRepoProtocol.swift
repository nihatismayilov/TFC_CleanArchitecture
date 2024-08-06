//
//  CityRepoProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Combine

public protocol LocationRepoProtocol {
    func getCity() -> AnyPublisher<Location, any Error>
    func getRegion() -> AnyPublisher<Location, any Error>
}
