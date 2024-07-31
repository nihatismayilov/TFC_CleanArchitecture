//
//  RegisterRemoteDTO.swift
//  data
//
//  Created by Nihad Ismayilov on 30.07.24.
//

import Foundation

struct TokenRemoteDTO: Decodable {
    let refreshToken: String
    let expiresAt: String
    let token: String
    let checkToken: String
}
