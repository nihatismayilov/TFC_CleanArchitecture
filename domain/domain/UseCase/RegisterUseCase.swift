//
//  RegisterUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 25.07.24.
//

import Foundation
import Combine

public class RegisterUseCase: BaseAsyncThrowsUseCase {
    private let repo: RegisterRepoProtocol
    
    init(repo: RegisterRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: String) async throws -> Bool {
        return try await repo.register(by: input)
    }
}
