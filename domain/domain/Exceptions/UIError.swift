//
//  UIError.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

public class UIError: Error {
    
    public let type: UIErrorType
    
    public init(type: UIErrorType) {
        self.type = type
    }
}

public enum UIErrorType: String {
    case unknown = ""
}
