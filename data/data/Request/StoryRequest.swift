//
//  StoryRequest.swift
//  data
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Alamofire

enum StoryRequest: Request {
    case storyForCustomer
    
    var baseUrl: BaseURL {
        .b2cBaseURL
    }
    
    var endpoint: String {
        switch self {
        case .storyForCustomer:
            "story/forCustomer"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .storyForCustomer:
                .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .storyForCustomer:
            return .body([:])
        }
    }
    
    var headers: [String : String]? {
        [:]
    }
}
