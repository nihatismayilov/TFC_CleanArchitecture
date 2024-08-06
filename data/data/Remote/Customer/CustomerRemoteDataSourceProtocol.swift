//
//  CustomerRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine

protocol CustomerRemoteDataSourceProtocol {
    func getProfile() -> AnyPublisher<ProfileRemoteDTO, Error>
}
