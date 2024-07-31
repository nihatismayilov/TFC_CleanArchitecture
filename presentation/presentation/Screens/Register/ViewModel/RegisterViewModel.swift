//
//  RegisterVM.swift
//  presentation
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine
import domain

public class RegisterViewModel: BaseViewModel {
    private let registerUseCase: RegisterUseCase
    var registerDataSubject: CurrentValueSubject<Bool?, Never> = .init(nil)
    var phoneIndexes: Set<String> = [
        "10",
        "50",
        "51",
        "55",
        "70",
        "77",
        "60",
        "99"
    ]
    
    public init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    func register(by phoneNumber: String?) {
        guard let phoneNumber else { return }
        showLoading()
        registerUseCase.register(by: "994\(phoneNumber)".trim())
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
    
    func observeRegister() -> AnyPublisher<Bool, Never> {
        registerDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func checkIndex(prefix: String) -> Bool {
        guard prefix.count >= 2 else {
            return true
        }
        if !phoneIndexes.contains(prefix) {
            return false
        } else {
            return true
        }
    }
}
