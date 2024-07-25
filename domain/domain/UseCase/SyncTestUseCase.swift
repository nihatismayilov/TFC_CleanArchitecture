//
//  SyncTestUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

public class SyncTestDataUseCase: BaseAsyncThrowsUseCase {
    private let repo: TestRepoProtocol
    
    init(repo: TestRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Void) async throws -> Void {
        try await self.repo.syncTestData()
    }
}
