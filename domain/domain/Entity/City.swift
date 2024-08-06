//
//  City.swift
//  domain
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation

public struct Location {
    public let data: [LocationData]?
    public let totalCount: Int?
    
    public init(data: [LocationData]?, totalCount: Int?) {
        self.data = data
        self.totalCount = totalCount
    }
}

public struct LocationData {
    public let id: Int?
    public let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
