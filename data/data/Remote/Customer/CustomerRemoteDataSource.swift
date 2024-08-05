//
//  CustomerRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Alamofire
import Combine

class CustomerRemoteDataSource: CustomerRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func getProfile() -> AnyPublisher<Bool, any Error> {
        let request = CustomerRequest.profile
        return dispatcher.execute(for: request)
    }
}
