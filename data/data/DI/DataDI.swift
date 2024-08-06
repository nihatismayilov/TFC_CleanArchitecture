//
//  DataDI.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

public struct DataDIConfigurator {
    public static func configure(container: DIContainer) {
        // MARK: - Logger
        container.register(ConsoleLogHandler.self, isSingleton: true) {
            ConsoleLogHandler()
        }
        
        container.register(Logger.self) {
            Logger(handlers: [container.resolve(ConsoleLogHandler.self)!])
        }
        
        container.register(NetworkLogger.self, isSingleton: true) {
            NetworkLogger(logger: container.resolve(Logger.self)!)
        }
        
        // TODO: - CoreDataClient
//        container.register(RealmClientProtocol.self) {
//            runBlocking {
//                await RealmClient()
//            }
//        }
        
        container.register(UserDefaultsStorageProtocol.self) {
            return UserDefaultsStorage(logger: container.resolve(Logger.self)!)
        }
        
        // MARK: - Network
        container.register(BaseInterceptor.self, isSingleton: true) {
            BaseInterceptor()
        }
        
        container.register(Dispatcher.self, isSingleton: true) {
            NetworkDispatcher(
                requestAdapter: [
                    container.resolve(BaseInterceptor.self)!,
                ],
                requestRetriers: [],
                logger: container.resolve(Logger.self)!,
                networkLogger: container.resolve(NetworkLogger.self)!,
                userDefaultsStorage: container.resolve(UserDefaultsStorageProtocol.self)!
            )
        }
        
        // MARK: - DataSource
//        container.register(TestLocalDataSourceProtocol.self) {
//            TestLocalDataSource(
////                realmClient: container.resolve(RealmClientProtocol.self)!
//            )
//        }
//        container.register(TestRemoteDataSourceProtocol.self) {
//            TestRemoteDataSource(networkClient: container.resolve(Dispatcher.self)!)
//        }
        container.register(RegisterRemoteDataSourceProtocol.self) {
            RegisterRemoteDataSource(dispatcher: container.resolve(Dispatcher.self)!)
        }
        
        container.register(CustomerRemoteDataSourceProtocol.self) {
            CustomerRemoteDataSource(dispatcher: container.resolve(Dispatcher.self)!)
        }
        
        container.register(LocationRemoteDataSourceProtocol.self) {
            LocationRemoteDataSource(dispatcher: container.resolve(Dispatcher.self)!)
        }
        
        // MARK: - Repo
//        container.register(TestRepoProtocol.self) {
//            TestRepo(
//                localDataSource: container.resolve(TestLocalDataSourceProtocol.self)!,
//                remoteDataSource: container.resolve(TestRemoteDataSourceProtocol.self)!
//            )
//        }
        container.register(RegisterRepoProtocol.self) {
            RegisterRepo(
                remoteDataSourceProtocol: container.resolve(RegisterRemoteDataSourceProtocol.self)!,
                userDefaultsStorage: container.resolve(UserDefaultsStorageProtocol.self)!
            )
        }
        container.register(CustomerRepoProtocol.self) {
            CustomerRepo(
                remoteDataSourceProtocol: container.resolve(CustomerRemoteDataSourceProtocol.self)!
            )
        }
        container.register(LocationRepoProtocol.self) {
            LocationRepo(
                remoteDataSourceProtocol: container.resolve(LocationRemoteDataSourceProtocol.self)!
            )
        }
    }
    
    static func runBlocking<T>(block: @escaping () async -> T) -> T {
        BlockingTask(block: block).wait()
    }
}

fileprivate class BlockingTask<T, E: Error> {
    private let semaphore = DispatchSemaphore(value: 0)
    private var result: Result<T, E>?

    init(block: @escaping () async -> T) where E == Never {
        Task {
            self.result = .success(await block())
            self.semaphore.signal()
        }
    }

    init(block: @escaping () async throws -> T) where E == Error {
        Task {
            do {
                self.result = .success(try await block())
            } catch {
                self.result = .failure(error)
            }
            self.semaphore.signal()
        }
    }

    func wait() -> T where E == Never {
        if let result { return try! result.get() }
        self.semaphore.wait()
        return try! self.result!.get()
    }

    func wait() -> Result<T, E> {
        if let result { return result }
        self.semaphore.wait()
        return self.result!
    }

    func wait() throws -> T {
        if let result { return try result.get() }
        self.semaphore.wait()
        return try self.result!.get()
    }
}
