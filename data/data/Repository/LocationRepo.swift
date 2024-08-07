//
//  CityRepo.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Combine
import domain

class LocationRepo: LocationRepoProtocol {
    private let remoteDataSourceProtocol: LocationRemoteDataSourceProtocol
    
    init(remoteDataSourceProtocol: LocationRemoteDataSourceProtocol) {
        self.remoteDataSourceProtocol = remoteDataSourceProtocol
    }
    
    func getCity() -> AnyPublisher<Location, any Error> {
        return remoteDataSourceProtocol.getCity()
            .receive(on: DispatchQueue.main)
            .map { data in
                return data.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func getRegion(by id: Int?) -> AnyPublisher<Location, any Error> {
        return remoteDataSourceProtocol.getRegion(by: id)
            .receive(on: DispatchQueue.main)
            .map { data in
                return data.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
