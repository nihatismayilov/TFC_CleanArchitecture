//
//  RegisterRemoteDataSourceProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation

protocol RegisterRemoteDataSourceProtocol {
    func register(by phoneNumber: String) async throws -> Bool
}
