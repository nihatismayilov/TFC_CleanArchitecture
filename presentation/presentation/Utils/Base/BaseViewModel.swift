//
//  BaseViewModel.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import Foundation
import Combine

open class BaseViewModel {
    private let isLoadingState: CurrentValueSubject<Bool, Never> = .init(false)
    private let baseEffectSubject: PassthroughSubject<BaseEffect, Never> = .init()
    
    var cancellables: Set<AnyCancellable> = .init()
    
    func showLoading() {
        isLoadingState.send(true)
    }
    
    func hideLoading() {
        isLoadingState.send(false)
    }
    
    func postBaseEffect(baseEffect: BaseEffect) {
        self.baseEffectSubject.send(baseEffect)
    }
    
    func showError(title: String = "", message: String) {
        baseEffectSubject.send(.error(title: title, message: message))
    }
    
    func observeLoading() -> AnyPublisher<Bool, Never> {
        return isLoadingState.eraseToAnyPublisher()
    }
    
    func observeBaseEffect() -> AnyPublisher<BaseEffect, Never> {
        return self.baseEffectSubject.eraseToAnyPublisher()
    }
    
//    open func observeError() -> AnyPublisher<String, Never> {
//        return errorSubject.eraseToAnyPublisher()
//    }
    
    func add(cancellable: AnyCancellable) {
        cancellable.store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

enum BaseEffect {
    case error(title: String = "", message: String)
}
