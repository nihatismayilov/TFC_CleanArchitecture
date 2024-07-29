//
//  BaseInterceptor.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        let baseHeader: HTTPHeader = HTTPHeader(name: "Accept", value: "application/json")
        
        urlRequest.headers.add(baseHeader)
        urlRequest.headers.add(HTTPHeader(name: "x-requestid", value: UUID().uuidString))

        completion(.success(urlRequest))
    }
}
