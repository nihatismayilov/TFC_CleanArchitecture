//
//  TestAPI.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

enum TestAPI: APIProtocol {
    case fetchCards
    case saveCards
    case getCards(_ customerId: String)
    
    var baseUrl: BaseURL {
        switch self {
        case .fetchCards:
                .ssbtBaseURL
        default:
                .b2cBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .fetchCards:
            return ""
        case .getCards(let customerId):
            return "/customers/\(customerId)/cards"
        default:
            return ""
        }
    }
}
