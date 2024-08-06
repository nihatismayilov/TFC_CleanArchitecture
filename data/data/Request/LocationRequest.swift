//
//  CityRequest.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Alamofire

enum LocationRequest: Request {
    case city
    case region
    
    var baseUrl: BaseURL {
        .b2cBaseURL
    }
    
    var endpoint: String {
        switch self {
        case .city:
            "city"
        case .region:
            "region"
        }
        
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: RequestParams {
        .body([:])
    }
    
    var headers: [String : String]? {
        [:]
    }
}
