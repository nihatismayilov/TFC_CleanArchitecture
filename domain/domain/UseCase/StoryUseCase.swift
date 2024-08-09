//
//  StoryUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Combine

protocol StoryUseCaseProtocol {
    func getStoryForCustomer() -> AnyPublisher<[StoryData], any Error>
}

public class StoryUseCase: StoryUseCaseProtocol {
    private let repo: StoryRepoProtocol
    
    init(repo: StoryRepoProtocol) {
        self.repo = repo
    }
    
    public func getStoryForCustomer() -> AnyPublisher<[StoryData], any Error> {
        return repo.getStory()
    }
}
