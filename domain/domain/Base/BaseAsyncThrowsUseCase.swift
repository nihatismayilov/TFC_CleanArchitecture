//
//  BaseAsyncThrowsUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

protocol BaseAsyncThrowsUseCase {
    associatedtype InputType

    associatedtype OutputType

    func execute(input: InputType) async throws -> OutputType
}
