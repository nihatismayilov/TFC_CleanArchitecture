//
//  OtpViewModel.swift
//  presentation
//
//  Created by Nihad Ismayilov on 30.07.24.
//

import Foundation
import Combine
import domain

public class OtpViewModel: BaseViewModel {
    private let registerUseCase: RegisterUseCase
    private let customerUseCase: CustomerUseCase
    var tokenDataSubject: CurrentValueSubject<Bool?, Never> = .init(nil)
    var registerDataSubject: CurrentValueSubject<Bool?, Never> = .init(nil)
    var profileDataSubject: CurrentValueSubject<Profile?, Never> = .init(nil)
    var phoneNumber: String = "+994 XX XXX XX XX"
    
    public init(registerUseCase: RegisterUseCase, customerUseCase: CustomerUseCase) {
        self.registerUseCase = registerUseCase
        self.customerUseCase = customerUseCase
    }
    
    func token(otp: String?) {
        guard let otp else { return }
        showLoading()
        registerUseCase.token(by: phoneNumber, otp: otp)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                hideLoading()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                tokenDataSubject.send(response.isSuccess)
            }
            .store(in: &cancellables)
    }
    
    func getProfile() {
        showLoading()
        customerUseCase.getProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                hideLoading()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                if response.isSuccess {
                    profileDataSubject.send(response)
                } else {
                    showError(message: response.message)
                }
            }
            .store(in: &cancellables)

    }
    
    func register() {
        showLoading()
        registerUseCase.register(by: "\(phoneNumber)".trim())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                hideLoading()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                if response {
                    registerDataSubject.send(response)
                } else {
                    showError(message: "Unknown error occured")
                }
            }
            .store(in: &cancellables)
    }
    
    func observeToken() -> AnyPublisher<Bool, Never> {
        tokenDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func observeProfile() -> AnyPublisher<Profile, Never> {
        profileDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func observeRegister() -> AnyPublisher<Bool, Never> {
        registerDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
}
