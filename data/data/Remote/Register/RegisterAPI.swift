//
//  RegisterAPI.swift
//  data
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation

enum RegisterAPI: APIProtocol {
    case register
    
    var baseUrl: BaseURL {
        switch self {
        case .register:
                .b2cBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .register:
            "customer/register"
        }
    }
}
