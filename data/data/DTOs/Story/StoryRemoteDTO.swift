//
//  StoryRemoteDTO.swift
//  data
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation

struct StoryRemoteDTO: Decodable {
    let id: Int?
    let title: String?
    let fileURL: String?
    let redirectURL: String?
    let priority: Int?
    let startDate, endDate: String?
    let isRead: Bool?
    
    let message: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case fileURL = "fileUrl"
        case redirectURL = "redirectUrl"
        case priority, startDate, endDate, isRead
        case message
    }
}
