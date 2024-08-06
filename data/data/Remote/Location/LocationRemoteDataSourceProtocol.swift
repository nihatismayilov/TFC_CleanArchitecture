//
//  CityRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Combine

protocol LocationRemoteDataSourceProtocol {
    func getCity() -> AnyPublisher<LocationRemoteDTO, Error>
    func getRegion() -> AnyPublisher<LocationRemoteDTO, Error>
}
