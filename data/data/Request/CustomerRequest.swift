//
//  CustomerRequest.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation
import Alamofire
import domain

enum CustomerRequest: Request {
    case profile
    case updateProfile(model: UpdateProfileModel)
    
    var baseUrl: BaseURL {
        switch self {
        case .profile:
                .b2cBaseURL
        case .updateProfile:
                .b2cBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .profile:
            "customer/profile"
        case .updateProfile:
            "customer"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .profile:
                .get
        case .updateProfile:
                .put
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .profile:
                return .body([:])
        case .updateProfile(let model):
            let params: [String: Any] = [
                "id": model.id,
                "name": model.name,
                "lastName": model.lastName,
                "nickName": model.nickName,
                "cityId": model.cityId,
                "cityName": model.cityName,
                "regionId": model.regionId,
                "fireBaseId": model.fireBaseId,
                "birthday": model.birthday
            ]
                return .body(params)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profile:
            [:]
        case .updateProfile(_):
            [:]
        }
    }
    
    
}
