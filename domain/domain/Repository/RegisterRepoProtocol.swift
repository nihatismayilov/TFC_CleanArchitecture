//
//  RegisterRepoProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine

public protocol RegisterRepoProtocol {
    func register(by phoneNumber: String) async throws -> Bool
}
