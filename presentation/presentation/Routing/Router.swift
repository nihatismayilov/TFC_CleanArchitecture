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
    static func getPersonalInformationViewController() -> PersonalInformationViewController {
        return DIContainer.shared.resolve(PersonalInformationViewController.self)!
    }
    static func getCitySelectionVC(selectedID: Int?) -> CitySelectionViewController {
        let vc = DIContainer.shared.resolve(CitySelectionViewController.self)!
        vc.viewModel.selectedID = selectedID
        return vc
    }
    static func getDistrictSelectionVC(selectedID : Int?, cityID: Int?) -> DistrictSelectionViewController {
        let vc = DIContainer.shared.resolve(DistrictSelectionViewController.self)!
        vc.viewModel.selectedID = selectedID
        vc.viewModel.cityID = cityID
        return vc
    }
    static func getHomeViewController() -> HomeViewController {
        return DIContainer.shared.resolve(HomeViewController.self)!
    }
    static func getStoryViewController(currentIndex: Int) -> StoryViewController {
        let vc = DIContainer.shared.resolve(StoryViewController.self)!
        vc.currentIndex = currentIndex
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    static func getBottomSheetVC() -> BottomSheetViewController {
        return DIContainer.shared.resolve(BottomSheetViewController.self)!
    }
    static func getOtpErrorVC() -> OtpErrorViewController {
        return DIContainer.shared.resolve(OtpErrorViewController.self)!
    }
}
