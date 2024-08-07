//
//  CityRemoteDTO.swift
//  data
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation

struct LocationRemoteDTO: Decodable {
    let data: [LocationData]?
    let totalCount: Int?
    
    struct LocationData: Decodable {
        let id: Int?
        let name: String?
        let regions: [RegionData]?
        
        struct RegionData: Decodable {
            let id: Int?
            let name: String?
        }
    }
}
