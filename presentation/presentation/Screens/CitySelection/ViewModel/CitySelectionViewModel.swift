//
//  CitySelectionVM.swift
//  presentation
//
//  Created by Rufat  on 31.07.24.
//

import Foundation
import Combine
import domain

class CitySelectionViewModel: BaseViewModel {
    let cityUseCase: LocationUseCase
    var cityDataSubject: CurrentValueSubject<[LocationData], Never> = .init([])
    var filteredCities = [LocationData]()
    var selectedID: Int?
    private var isCitySelected: Bool = false
    
    public init(cityUseCase: LocationUseCase) {
        self.cityUseCase = cityUseCase
    }
    
    func getCity() {
        showLoading()
        
        cityUseCase.getCity()
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
            } receiveValue: { [weak self] cityData in
                guard let self else { return }
                filteredCities = cityData.data ?? []
                cityDataSubject.send(cityData.data ?? [])
            }
            .store(in: &cancellables)
    }
    
    func observeCity() -> AnyPublisher<[LocationData], Never> {
        cityDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func filterCities(text: String?) {
        if let text, text != "" {
            filteredCities = cityDataSubject.value.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
        } else {
            filteredCities = cityDataSubject.value
        }
    }
}
