//
//  StoryRemoteDataSourseProtocol.swift
//  data
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Combine

protocol StoryRemoteDataSourceProtocol {
    func getStory() -> AnyPublisher<[StoryRemoteDTO], Error>
}
