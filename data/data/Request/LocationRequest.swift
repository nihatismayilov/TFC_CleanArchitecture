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
    
    var baseUrl: BaseURL {
        .b2cBaseURL
    }
    
    var endpoint: String {
        "city"
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
