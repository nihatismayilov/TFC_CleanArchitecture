//
//  Token.swift
//  domain
//
//  Created by Nihad Ismayilov on 31.07.24.
//

import Foundation

public struct Token {
    public let isSuccess: Bool
    public let message: String
    
    public init(
        isSuccess: Bool,
        message: String
    ) {
        self.isSuccess = isSuccess
        self.message = message
    }
}
