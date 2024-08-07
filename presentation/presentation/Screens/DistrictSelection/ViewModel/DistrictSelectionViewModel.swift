//
//  DistrictSelectionViewModel.swift
//  presentation
//
//  Created by Rufat  on 01.08.24.
//

import Foundation
import Combine
import domain

class DistrictSelectionViewModel : BaseViewModel{
    let regionUseCase: LocationUseCase
    var regionDataSubject: CurrentValueSubject<[RegionData], Never> = .init([])
    var filteredRegions = [RegionData]()
    var selectedID: Int?
    var cityID: Int?
    private var isRegionSelected: Bool = false
    
    public init(regionUseCase: LocationUseCase) {
        self.regionUseCase = regionUseCase
    }
    
    func getDistrict() {
        showLoading()
        
        regionUseCase.getCity()
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
                guard let cityID else {
                    return
                }
                let districtData = cityData.data?.first(where: {$0.id == cityID})?.regions
                filteredRegions = districtData ?? []
                regionDataSubject.send(districtData ?? [])
            }
            .store(in: &cancellables)
    }
    
    func observeDistrict() -> AnyPublisher<[RegionData], Never> {
        regionDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func filterDistricts(text: String?) {
        if let text, text != "" {
            filteredRegions = regionDataSubject.value.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
        } else {
            filteredRegions = regionDataSubject.value
        }
    }
}
