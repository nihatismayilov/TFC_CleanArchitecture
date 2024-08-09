//
//  StoryRepo.swift
//  data
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Combine
import domain

class StoryRepo: StoryRepoProtocol {
    private let remoteDataSourceProtocol: StoryRemoteDataSourceProtocol
    
    init(remoteDataSourceProtocol: StoryRemoteDataSourceProtocol) {
        self.remoteDataSourceProtocol = remoteDataSourceProtocol
    }
    
    func getStory() -> AnyPublisher<[StoryData], any Error> {
        return remoteDataSourceProtocol.getStory()
            .receive(on: DispatchQueue.main)
            .map { data in
                return data.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
