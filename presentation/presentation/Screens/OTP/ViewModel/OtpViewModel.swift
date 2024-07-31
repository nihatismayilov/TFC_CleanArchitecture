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
    var tokenDataSubject: CurrentValueSubject<Bool?, Never> = .init(nil)
    var phoneNumber: String = "+994 XX XXX XX XX"
    
    public init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
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
                if response {
                    tokenDataSubject.send(response)
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
}
