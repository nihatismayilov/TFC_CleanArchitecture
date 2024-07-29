//
//  RegisterVM.swift
//  presentation
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine
import domain

class RegisterVM: BaseViewModel {
    private let registerUseCase: RegisterUseCase
    var registerSuccess: Bool? = nil
    
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    func register(by phoneNumber: String) {
        Task {
            await syncRegisterData(phoneNumber: phoneNumber)
        }
        print("success here", registerSuccess)

    }
    
    func syncRegisterData(phoneNumber: String) async {
        do {
            registerSuccess = try await registerUseCase.execute(input: phoneNumber)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
