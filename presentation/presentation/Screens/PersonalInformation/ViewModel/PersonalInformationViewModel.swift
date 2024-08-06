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
    var model = PersonalInformationModel()
    
    init(customerUseCase: CustomerUseCase) {
        self.customerUseCase = customerUseCase
    }
}
