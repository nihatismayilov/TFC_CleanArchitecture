//
//  BaseAsyncThrowsUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine

protocol BaseAsyncThrowsUseCase {
    associatedtype InputType

    associatedtype OutputType

    func execute(input: InputType) -> AnyPublisher<OutputType, any Error>
}
