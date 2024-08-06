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
    var RegionDataSubject: CurrentValueSubject<[LocationData], Never> = .init([])
    var filteredRegions = [LocationData]()
    var selectedID: Int?
    private var isRegionSelected: Bool = false
    
    public init(regionUseCase
                : LocationUseCase) {
        self.regionUseCase = regionUseCase
    }
    
    func getDistrict() {
        showLoading()
        
        regionUseCase.getRegion()
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
            } receiveValue: { [weak self] DistrictData in
                guard let self else { return }
                filteredRegions = DistrictData.data ?? []
                RegionDataSubject.send(DistrictData.data ?? [])
            }
            .store(in: &cancellables)
    }
    
    func observeDistrict() -> AnyPublisher<[LocationData], Never> {
        RegionDataSubject.compactMap {$0}
            .eraseToAnyPublisher()
    }
    
    func filterDistricts(text: String?) {
        if let text, text != "" {
            filteredRegions = RegionDataSubject.value.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
        } else {
            filteredRegions = RegionDataSubject.value
        }
    }
}
