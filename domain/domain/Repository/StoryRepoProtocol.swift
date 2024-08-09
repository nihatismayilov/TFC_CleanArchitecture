//
//  StoryRepoProtocol.swift
//  domain
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Combine

public protocol StoryRepoProtocol {
    func getStory() -> AnyPublisher<[StoryData], any Error>
}
