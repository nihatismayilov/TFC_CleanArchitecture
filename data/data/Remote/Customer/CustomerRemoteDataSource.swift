//
//  CustomerRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Alamofire
import Combine
import domain

class CustomerRemoteDataSource: CustomerRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func getProfile() -> AnyPublisher<ProfileRemoteDTO, any Error> {
        let request = CustomerRequest.profile
        return dispatcher.execute(for: request)
    }
    
    func updateProfile(model: UpdateProfileModel) -> AnyPublisher<ProfileRemoteDTO, any Error> {
        let request = CustomerRequest.updateProfile(model: model)
        return dispatcher.execute(for: request)
    }
}
