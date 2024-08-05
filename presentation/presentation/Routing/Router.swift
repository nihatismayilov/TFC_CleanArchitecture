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
    
    static func getTabbarController() -> TabbarController {
        return DIContainer.shared.resolve(TabbarController.self)!
    }
    
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
    static func getCitySelectionVC() -> CitySelectionViewController {
        return DIContainer.shared.resolve(CitySelectionViewController.self)!
    }
    static func getDistrictSelectionVC() -> DistrictSelectionViewController {
        return DIContainer.shared.resolve(DistrictSelectionViewController.self)!
    }
    static func getBottomSheetVC() -> BottomSheetViewController {
        return DIContainer.shared.resolve(BottomSheetViewController.self)!
    }
}
