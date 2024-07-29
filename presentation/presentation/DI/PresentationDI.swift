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
        container.register(RegisterVC.self) {
            RegisterVC(vm: container.resolve(RegisterVM.self)!)
        }
        container.register(OtpVC.self) {
            OtpVC(vm: container.resolve(BaseViewModel.self)!)
        }
        container.register(PersonalInformationVC.self) {
            PersonalInformationVC(vm: container.resolve(BaseViewModel.self)!)
        }
        // MARK: - View Models
        container.register(BaseViewModel.self) {
            BaseViewModel()
        }
        
        container.register(RegisterVM.self) {
            return RegisterVM(registerUseCase: container.resolve(RegisterUseCase.self)!)
        }
    }
}
