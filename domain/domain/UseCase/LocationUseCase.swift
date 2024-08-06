//
//  CityUseCase.swift
//  domain
//
//  Created by Nihad Ismayilov on 05.08.24.
//

import Foundation
import Combine

protocol LocationUseCaseProtocol {
    func getCity() -> AnyPublisher<Location, Error>
}

public class LocationUseCase: LocationUseCaseProtocol {
    private let repo: LocationRepoProtocol
    
    init(repo: LocationRepoProtocol) {
        self.repo = repo
    }
    
    public func getCity() -> AnyPublisher<Location, any Error> {
        return repo.getCity()
    }
    
    public func getRegion() -> AnyPublisher<Location, any Error> {
        return repo.getRegion()
    }
}
