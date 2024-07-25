//
//  ObserveTestUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Combine

public class ObserveTestDataUseCase: BaseObservableUseCase {
    private let repo: TestRepoProtocol
    
    init(repo: TestRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Void) -> AnyPublisher<[Test], Never> {
        return self.repo.observeTestData()
    }
}
