//
//  Profile.swift
//  domain
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation

public struct Profile {
    public let id: Int?
    public let phoneNumber: String?
    public let name: String?
    public let lastName: String?
    public let nickName: String?
    public let currentBalance: Double?
    public let cityId: Int?
    public let cityName: String?
    public let regionId: Int?
    public let regionName: String?
    public let fileUrl: String?
    public let locked: Bool?
    public let birthDay: String?
    public let status: Bool?
    public let fireBaseId: String?
    public let lotteryStatus: Int?
    public let email: String?
    public let passportFin: String?
    public let passportNumber: String?
    public let statusConfirmedIDCard: Int?
    
    public let isSuccess: Bool?
    public let message: String?
    
    public init(id: Int?, phoneNumber: String?, name: String?, lastName: String?, nickName: String?, currentBalance: Double?, cityId: Int?, cityName: String?, regionId: Int?, regionName: String?, fileUrl: String?, locked: Bool?, birthDay: String?, status: Bool?, fireBaseId: String?, lotteryStatus: Int?, email: String?, passportFin: String?, passportNumber: String?, statusConfirmedIDCard: Int?, isSuccess: Bool, message: String) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
        self.lastName = lastName
        self.nickName = nickName
        self.currentBalance = currentBalance
        self.cityId = cityId
        self.cityName = cityName
        self.regionId = regionId
        self.regionName = regionName
        self.fileUrl = fileUrl
        self.locked = locked
        self.birthDay = birthDay
        self.status = status
        self.fireBaseId = fireBaseId
        self.lotteryStatus = lotteryStatus
        self.email = email
        self.passportFin = passportFin
        self.passportNumber = passportNumber
        self.statusConfirmedIDCard = statusConfirmedIDCard
        self.isSuccess = isSuccess
        self.message = message
    }
}

public struct UpdateProfileModel {
    public var id: Int?
    public var name: String?
    public var lastName: String?
    public var nickName: String?
    public var cityId: Int?
    public var cityName: String?
    public var regionId: Int?
    public var regionName: String?
    public var fireBaseId: String?
    public var birthday: String?
    
    public init(id: Int? = nil, name: String? = nil, lastName: String? = nil, nickName: String? = nil, cityId: Int? = nil, cityName: String? = nil, regionId: Int? = nil, regionName: String? = nil, fireBaseId: String? = nil, birthday: String? = nil) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.nickName = nickName
        self.cityId = cityId
        self.cityName = cityName
        self.regionId = regionId
        self.regionName = regionName
        self.fireBaseId = fireBaseId
        self.birthday = birthday
    }
}
