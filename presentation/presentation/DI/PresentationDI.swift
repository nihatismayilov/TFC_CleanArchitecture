//
//  PresentationDI.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

public struct PresentationDIConfigurator {
    public static func configure(container: DIContainer) {
        // MARK: - View Controllers
        container.register(TabbarController.self) {
            TabbarController()
        }
        container.register(ForceUpdateVC.self) {
            ForceUpdateVC(vm: container.resolve(BaseViewModel.self)!)
        }
        container.register(RegisterViewController.self) {
            RegisterViewController(vm: container.resolve(RegisterViewModel.self)!)
        }
        container.register(OtpViewController.self) {
            OtpViewController(vm: container.resolve(OtpViewModel.self)!)
        }
        container.register(PersonalInformationVC.self) {
            PersonalInformationVC(vm: container.resolve(BaseViewModel.self)!)
        }
        container.register(CitySelectionViewController.self) {
            CitySelectionViewController(vm: container.resolve(CitySelectionViewModel.self)!)
        }
        container.register(DistrictSelectionViewController.self) {
            DistrictSelectionViewController(vm: container.resolve(DistrictSelectionViewModel.self)!)
        }
        container.register(BottomSheetViewController.self) {
            BottomSheetViewController()
        }
        // MARK: - View Models
        container.register(BaseViewModel.self) {
            BaseViewModel()
        }
        
        container.register(RegisterViewModel.self) {
            return RegisterViewModel(registerUseCase: container.resolve(RegisterUseCase.self)!)
        }
        container.register(OtpViewModel.self) {
            return OtpViewModel(
                registerUseCase: container.resolve(RegisterUseCase.self)!,
                customerUseCase: container.resolve(CustomerUseCase.self)!
            )
        }
        container.register(CitySelectionViewModel.self) {
            return CitySelectionViewModel()
        }
        container.register(DistrictSelectionViewModel.self) {
            return DistrictSelectionViewModel()
        }
    }
}
