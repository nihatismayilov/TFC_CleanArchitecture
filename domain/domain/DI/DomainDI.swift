//
//  DomainDI.swift
//  domain
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

protocol DIContainerProtocol {
    func register<T>(_ type: T.Type, isSingleton: Bool, _ factory: @escaping () -> T)
    func resolve<T>(_ type: T.Type) -> T?
}

public class DIContainer: DIContainerProtocol {
    public static let shared = DIContainer()
    private var registry = [String: () -> Any]()
    private var singletons = [String: Any]()

    public func register<T>(_ type: T.Type, isSingleton: Bool = false, _ factory: @escaping () -> T) {
        let key = String(describing: type)
        if isSingleton {
            if singletons[key] == nil {
                singletons[key] = factory()
            }
        } else {
            registry[key] = factory
        }
    }

    public func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        if let singleton = singletons[key] as? T {
                    return singleton
                }
        return registry[key]?() as? T
    }
}

public struct DomainDIConfigurator {
    public static func configure(container: DIContainer) {
//        container.register(SyncTestDataUseCase.self) {
//            SyncTestDataUseCase(repo: container.resolve(TestRepoProtocol.self)!)
//        }
//        container.register(ObserveTestDataUseCase.self) {
//            ObserveTestDataUseCase(repo: container.resolve(TestRepoProtocol.self)!)
//        }
        
        container.register(RegisterUseCase.self) {
            RegisterUseCase(repo: container.resolve(RegisterRepoProtocol.self)!)
        }
        
        container.register(CustomerUseCase.self) {
            CustomerUseCase(repo: container.resolve(CustomerRepoProtocol.self)!)
        }
        
        container.register(LocationUseCase.self) {
            LocationUseCase(repo: container.resolve(LocationRepoProtocol.self)!)
        }
        
        container.register(StoryUseCase.self) {
            StoryUseCase(repo: container.resolve(StoryRepoProtocol.self)!)
        }
    }
}
