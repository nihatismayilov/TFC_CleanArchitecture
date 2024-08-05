//
//  Configuration.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

protocol APIProtocol {
    var endpoint: String { get }
    var baseUrl: BaseURL { get }
//    var method: HTTPMethod { get }
//    var headers: HTTPHeaders? { get }
}

enum JSON {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
}

//enum BaseURL: String {
//    case b2cBaseURL = "https://b2capicr.topaz.net.az/" // MARK: PROD
////    case b2cBaseURL = "https://b2capicr.topaz.net.az/" // MARK: TEST
//    
//    case socketBaseURL = "wss://bbws.topaz.net.az" // MARK: PROD
////    case socketBaseURL = "wss://stbbws.topaz.net.az" // MARK: TEST
//    
//    case ssbtBaseURL = "https://tps.topaz.net.az/api/terminal/" // MARK: PROD
////    case ssbtBaseURL = "https://sttps.topaz.net.az/api/terminal/" // MARK: TEST
//    
//    case paymentBaseURL = "https://payr.topaz.net.az/api/" // MARK: PROD
////    case paymentBaseURL = "https://stpayr.topaz.net.az/api/" // MARK: TEST
//}
