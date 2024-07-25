//
//  Router.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

class Router {
    private init() {}
    
    static func getTestVC() -> TestVC {
        return DIContainer.shared.resolve(TestVC.self)!
    }
    static func getRegisterVC() -> RegisterVC {
        return DIContainer.shared.resolve(RegisterVC.self)!
    }
    static func getOtpVC() -> OtpVC {
        return DIContainer.shared.resolve(OtpVC.self)!
    }
    static func getForceUpdateVC() -> ForceUpdateVC {
        return DIContainer.shared.resolve(ForceUpdateVC.self)!
    }
}
