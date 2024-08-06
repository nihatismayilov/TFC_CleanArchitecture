//
//  CityRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Alamofire
import Combine

class LocationRemoteDataSource: LocationRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func getCity() -> AnyPublisher<LocationRemoteDTO, any Error> {
        let request = LocationRequest.city
        return dispatcher.execute(for: request)
    }
    
    func getRegion() -> AnyPublisher<LocationRemoteDTO, any Error> {
        let request = LocationRequest.region
        return dispatcher.execute(for: request)
    }
}
