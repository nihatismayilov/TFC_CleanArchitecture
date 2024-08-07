//
//  CustomerRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Combine
import domain

protocol CustomerRemoteDataSourceProtocol {
    func getProfile() -> AnyPublisher<ProfileRemoteDTO, Error>
    func updateProfile(model: UpdateProfileModel) -> AnyPublisher<ProfileRemoteDTO, Error>
}
