//
//  RegisterRequest.swift
//  data
//
//  Created by Nihad Ismayilov on 29.07.24.
//

import Foundation
import Alamofire

enum RegisterRequest: Request {
    case register(params: [String: Any])
    case token(params: [String: Any])
    
    var baseUrl: BaseURLTEST {
        switch self {
        default:
                .b2cBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .register(_):
            "customer/register"
        case .token(_):
            "customer/token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register(_):
                .post
        case .token(_):
                .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .register(let params):
            return .body(params)
        case .token(let params):
            return .body(params)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .register(let params):
            [:]
        default:
            [:]
        }
    }
}
