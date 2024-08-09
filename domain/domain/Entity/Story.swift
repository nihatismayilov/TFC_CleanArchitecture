//
//  Story.swift
//  domain
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation

public struct StoryData {
    public let id: Int?
    public let title: String?
    public let fileURL: String?
    public let redirectURL: String?
    public let priority: Int?
    public let startDate, endDate: String?
    public let isRead: Bool?
    
    public let isSuccess: Bool?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case fileURL = "fileUrl"
        case redirectURL = "redirectUrl"
        case priority, startDate, endDate, isRead
    }
    
    public init(id: Int?, title: String?, fileURL: String?, redirectURL: String?, priority: Int?, startDate: String?, endDate: String?, isRead: Bool?, isSuccess: Bool?, message: String?) {
        self.id = id
        self.title = title
        self.fileURL = fileURL
        self.redirectURL = redirectURL
        self.priority = priority
        self.startDate = startDate
        self.endDate = endDate
        self.isRead = isRead
        self.isSuccess = isSuccess
        self.message = message
    }
}
