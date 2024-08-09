//
//  StoryRemoteDataSource.swift
//  data
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Alamofire
import Combine

class StoryRemoteDataSource: StoryRemoteDataSourceProtocol {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func getStory() -> AnyPublisher<[StoryRemoteDTO], Error> {
        let request = StoryRequest.storyForCustomer
        return dispatcher.execute(for: request)
    }
}
