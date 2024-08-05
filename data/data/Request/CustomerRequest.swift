//
//  CustomerRequest.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Alamofire

enum CustomerRequest: Request {
    case profile
    
    var baseUrl: BaseURL {
        switch self {
        case .profile:
                .b2cBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .profile:
            "customer/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .profile:
                .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .profile:
                .body([:])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profile:
            [:]
        }
    }
    
    
}
