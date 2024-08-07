//
//  PersonalInformationViewModel.swift
//  presentation
//
//  Created by Nihad Ismayilov on 06.08.24.
//

import Foundation
import Combine
import domain

public class PersonalInformationViewModel: BaseViewModel {
    let customerUseCase: CustomerUseCase
    var profileDataSubject: CurrentValueSubject<Profile?, Never> = .init(nil)
    var model = UpdateProfileModel()
    
    init(customerUseCase: CustomerUseCase) {
        self.customerUseCase = customerUseCase
    }
    
    func updateProfile() {
        showLoading()
        customerUseCase.updateProfile(model: model)
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
                if response.isSuccess == true {
                    profileDataSubject.send(response)
                } else {
                    showError(message: response.message.orEmpty)
                }
            }
            .store(in: &cancellables)
    }
    
    func observeProfile() -> AnyPublisher<Profile, Never> {
        profileDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func isButtonActive() -> Bool {
        !model.name.isNilOrEmpty &&
        !model.lastName.isNilOrEmpty &&
        !model.nickName.isNilOrEmpty &&
        !model.cityId.isNilOrZero &&
        !model.regionId.isNilOrZero &&
        !model.birthday.isNilOrEmpty
    }
}
