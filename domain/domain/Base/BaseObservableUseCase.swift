//
//  BaseObservableUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine

protocol BaseObservableUseCase {
    associatedtype InputType
    
    associatedtype OutputType
    
    func observe(input: InputType) -> AnyPublisher<OutputType, Never>
}
