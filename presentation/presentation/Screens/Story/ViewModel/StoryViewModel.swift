//
//  StoryViewModel.swift
//  presentation
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import Foundation
import Combine
import domain

public class StoryViewModel: BaseViewModel {
    private let storyUseCase: StoryUseCase
    var storyDataSubject: CurrentValueSubject<[StoryData]?, Never> = .init(nil)
    
    public init(storyUseCase: StoryUseCase) {
        self.storyUseCase = storyUseCase
    }
    
    func getStory() {
        showLoading()
        storyUseCase.getStoryForCustomer()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                hideLoading()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                storyDataSubject.send(response)
            }
            .store(in: &cancellables)
    }
    
    func getStories() -> [StoryData] {
        storyDataSubject.value ?? []
    }
    
    func observeStory() -> AnyPublisher<[StoryData], Never> {
        storyDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
}
