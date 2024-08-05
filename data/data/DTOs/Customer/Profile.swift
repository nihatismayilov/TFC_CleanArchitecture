//
//  Profile.swift
//  data
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation

struct ProfileRemoteDTO: Decodable {
    let id: Int?
    let phoneNumber: String?
    let name: String
    let lastName: String?
    let nickName: String?
    let currentBalance: Double?
    let score: Double?
    let redeem: Double?
    let cityId: Int?
    let cityName: String?
    let regionId: Int?
    let regionName: String?
    let fileUrl: String?
    let locked: Bool?
    let birthDay: String?
    let lastLoginDate: String?
    let lastUpdateDate: String?
    let registerDate: String?
    let device: String?
    let status: Bool?
    let fireBaseId: String?
    let badgeId: Int?
    let badgeName: String?
    let wonTicketCount: Int?
    let lostTicketCount: Int?
    let winningGames: Int?
    let defeatGames: Int?
    let langId: Int?
    let agentId: Int?
    let agentName: String?
    let agentNumber: String?
    let firstScanDate: String?
    let lotteryStatus: Int?
    let email: String?
    let passportFin: String?
    let passportNumber: String?
    let statusConfirmedIDCard: Int?
    let expDt: String?
    
    let message: String?
}
