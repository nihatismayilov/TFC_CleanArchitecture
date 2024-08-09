//
//  LocalToDomainMappers.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

//extension TestLocalDTO {
//    func toDomain() -> Test {
//        return Test(
//            id: self.id,
//            test: self.test
//        )
//    }
//}

extension TokenRemoteDTO {
    func toDomain() -> Token {
        let isSuccess = refreshToken?.isEmpty == false &&
                        token?.isEmpty == false &&
                        checkToken?.isEmpty == false
        return Token(
            isSuccess: isSuccess,
            message: message.orEmpty
        )
    }
}

extension ProfileRemoteDTO {
    func toDomain() -> Profile {
        return Profile(
            id: id,
            phoneNumber: phoneNumber,
            name: name,
            lastName: lastName,
            nickName: nickName,
            currentBalance: currentBalance,
            cityId: cityId,
            cityName: cityName,
            regionId: regionId,
            regionName: regionName,
            fileUrl: fileUrl,
            locked: locked,
            birthDay: birthDay,
            status: status,
            fireBaseId: fireBaseId,
            lotteryStatus: lotteryStatus,
            email: email,
            passportFin: passportFin,
            passportNumber: passportNumber,
            statusConfirmedIDCard: statusConfirmedIDCard,
            isSuccess: message == nil,
            message: message ?? "unknown error occured"
        )
    }
}

extension LocationRemoteDTO.LocationData.RegionData {
    func toDomain() -> RegionData {
        return RegionData(id: id, name: name)
    }
}

extension LocationRemoteDTO.LocationData {
    func toDomain() -> LocationData {
        return LocationData(id: id, name: name, regions: regions.map({$0.map {$0.toDomain()}}))
    }
}

extension LocationRemoteDTO {
    func toDomain() -> Location {
        return Location(data: data.map({$0.map {$0.toDomain()}}), totalCount: totalCount)
    }
}

extension [StoryRemoteDTO] {
    func toDomain() -> [StoryData] {
        return self.map { data in
            return StoryData(
                id: data.id,
                title: data.title,
                fileURL: data.fileURL,
                redirectURL: data.redirectURL,
                priority: data.priority,
                startDate: data.startDate,
                endDate: data.endDate,
                isRead: data.isRead,
                isSuccess: data.id != nil,
                message: data.message
            )
        }
    }
}
