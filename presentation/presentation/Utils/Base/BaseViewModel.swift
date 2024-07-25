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
    
//    private let stateSubject: CurrentValueSubject<State?, Never> = .init(nil)
//    private let effectSubject: PassthroughSubject<Effect, Never> = .init()
    
//    private let baseEffectSubject: PassthroughSubject<BaseEffect, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    internal func setLoading(state: Bool) {
        self.isLoadingState.send(state)
    }
    
    internal func showLoading() {
        self.isLoadingState.send(true)
    }
    
    internal func hideLoading() {
        self.isLoadingState.send(false)
    }
    
    open func observeLoading() -> AnyPublisher<Bool, Never> {
        return self.isLoadingState.eraseToAnyPublisher()
    }
    
//    internal func postEffect(effect: Effect) {
//        self.effectSubject.send(effect)
//    }
    
//    internal func postBaseEffect(baseEffect: BaseEffect) {
//        self.baseEffectSubject.send(baseEffect)
//    }
    
//    internal func postState(state: State) {
//        self.stateSubject.send(state)
//    }
    
//    func observeEffect() -> AnyPublisher<Effect, Never> {
//        return self.effectSubject.eraseToAnyPublisher()
//    }
    
//    func observeBaseEffect() -> AnyPublisher<BaseEffect, Never> {
//        return self.baseEffectSubject.eraseToAnyPublisher()
//    }
    
//    func observeState() -> AnyPublisher<State, Never> {
//        self.stateSubject.compactMap { $0 }
//            .eraseToAnyPublisher()
//    }
    
//    func getState() -> State? {
//        return self.stateSubject.value
//    }
    
    func add(cancellable: AnyCancellable) {
        cancellable.store(in: &self.cancellables)
    }
    
//    func show(error: Error) {
//        self.postBaseEffect(baseEffect: .error(error))
//    }

    deinit {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
}

enum BaseEffect {
    case error(Error)
}
