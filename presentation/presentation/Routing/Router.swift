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
    
    static func getForceUpdateVC() -> ForceUpdateVC {
        return DIContainer.shared.resolve(ForceUpdateVC.self)!
    }
    static func getRegisterVC() -> RegisterViewController {
        return DIContainer.shared.resolve(RegisterViewController.self)!
    }
    static func getOtpVC(phoneNumber: String) -> OtpViewController {
        let vc = DIContainer.shared.resolve(OtpViewController.self)!
        vc.viewModel.phoneNumber = phoneNumber
        return vc
    }
    static func getPersonalInformationVC() -> PersonalInformationVC {
        return DIContainer.shared.resolve(PersonalInformationVC.self)!
    }
}
