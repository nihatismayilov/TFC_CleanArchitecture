//
//  NetworkDispatcher.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Alamofire
import Combine
import domain

protocol Dispatcher {
    func execute<Response: Decodable>(for request: Request) -> AnyPublisher<Response, Error>
}

class NetworkDispatcher: Dispatcher {
    private var cancellables: Set<AnyCancellable> = []
    private let session: Session
    private let logger: Logger
    
    init(
        requestAdapter: [RequestAdapter],
        requestRetriers: [RequestRetrier],
        logger: Logger,
        networkLogger: NetworkLogger
    ) {
        
        self.session = Session(
            interceptor: Interceptor(
                adapters: requestAdapter,
                retriers: requestRetriers
            )
        )
        self.logger = logger
    }
    
    public func execute<Response: Decodable>(for request: Request) -> AnyPublisher<Response, Error> {
            return Future<Response, Error> { [weak self] promise in
                guard let self else {
                    promise(.failure(NetworkErrors.unknownError(0)))
                    return
                }
                
                if !ConnectionChecker.isConnectedToNetwork() {
                    promise(.failure(NetworkErrors.connection))
                    return
                }
                
                do {
                    let urlRequest = try self.urlRequest(for: request)
                    self.performRequest(urlRequest, promise: promise)
                } catch {
                    promise(.failure(error))
                }
                
            }.eraseToAnyPublisher()
        }
    
    private func performRequest<Response: Decodable>(_ urlRequest: URLRequest, promise: @escaping (Result<Response, Error>) -> Void) {
        print("\nURLREQUEST: \((urlRequest.url?.absoluteString).orEmpty) \(urlRequest.httpMethod.orEmpty)\n")
        
        session.request(urlRequest)
            .publishData()
            .tryMap { dataResponse in
                guard let statusCode = dataResponse.response?.statusCode else {
                    throw NetworkErrors.messageError("Unknown error - could not get status code")
                }
                
                if dataResponse.response?.statusCode == 204 {
                    return try JSON.encoder.encode(true)
                }
                
                guard let data = dataResponse.data else {
                    throw NetworkErrors.messageError("Unknown error - data could not be found")
                }
                print("DATA: \n", data.prettyPrintedJSONString ?? "")
                
                switch statusCode {
                case 401:
                    throw NetworkErrors.unauthorized
                case 200...600:
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        guard let datas = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                            throw NetworkErrors.messageError("ERROR - CODE 2")
                        }
                        return datas
                    } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        if statusCode == 200 || statusCode == 201 {
                            guard let datas = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                                throw NetworkErrors.messageError("ERROR - CODE 2")
                            }
                            return datas
                        } else {
                            throw NetworkErrors.unknownError(statusCode)
                        }
                    } else {
                        throw NetworkErrors.unknownError(statusCode)
                    }
                default:
                    throw NetworkErrors.unknownError(statusCode)
                }
                
//                return data
            }
            .decode(type: Response.self, decoder: JSON.decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    promise(.failure(error))
                }
            }, receiveValue: { response in
                promise(.success(response))
            })
            .store(in: &cancellables)
    }
        
        private func urlRequest(for request: Request) throws -> URLRequest {
            var fullURL = "\(request.baseUrl.rawValue)\(request.endpoint)"
            var urlRequest = URLRequest(url: URL(string: fullURL)!)
            
            switch request.parameters {
            case .body(let params):
                if let params = params {
                    if !params.isEmpty {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                        print("REQUEST BODY: \(try JSONSerialization.data(withJSONObject: params, options: []).prettyPrintedJSONString ?? "NONE")\n")
                    }
                } else {
                    throw NetworkErrors.badInput
                }
            case .url(let params, let isQuery):
                if let params = params as? [String: String] {
                    if isQuery {
                        let queryParams = params.map { URLQueryItem(name: $0.key, value: $0.value) }
                        var components = URLComponents(string: fullURL)!
                        components.queryItems = queryParams
                        urlRequest.url = components.url
                    } else {
                        let queryString = params.map { $0.value }.joined(separator: "/")
                        fullURL += queryString
                        urlRequest = URLRequest(url: URL(string: fullURL)!)
                    }
                } else {
                    throw NetworkErrors.badInput
                }
            }
            
//            if request.hasHeader {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(UUID().uuidString, forHTTPHeaderField: "x-requestid")
//            }
            
            request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
            
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.timeoutInterval = 120
            
            print("HEADERS: \n", urlRequest.allHTTPHeaderFields ?? [:])
            
            return urlRequest
        }
}

enum NetworkErrors: Error, LocalizedError, Equatable {
    case connection
    case badInput
    case noData
    case unauthorized
    case notFound
    case methodNotAllowed
    case badRequest
    case notSupportedURL
    case unknownError(Int)
    case messageError(String)
    
    var errorDescription: String? {
        switch self {
        case .connection:
            return "No connection"
        case .badInput:
            return "Bad input"
        case .noData:
            return "No data found"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "404 Not found"
        case .methodNotAllowed:
            return "This http method is not allowed"
        case .badRequest:
            return "Bad reques"
        case .notSupportedURL:
            return "URL not supported"
        case .unknownError(let code):
            return "\(code) - Unknown error"
        case .messageError(let message):
            return message
        }
    }
}

import SystemConfiguration

class ConnectionChecker {
    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

extension String? {
    var orEmpty: String {
        self ?? ""
    }
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}

protocol Request {
    var endpoint: String { get }
    
    var baseUrl: BaseURL { get }
    
    var method: HTTPMethod { get }
    
    var parameters: RequestParams { get }
    
    var headers: [String: String]? { get }
    
//    var authentication: Bool { get }
    
//    var hasHeader: Bool { get }
}

enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?, isQuery: Bool = true)
}

enum BaseURL: String {
    case b2cBaseURL = "https://b2capicr.topaz.net.az/" // MARK: PROD
//    case b2cBaseURL = "https://b2capicr.topaz.net.az/" // MARK: TEST
    
//    case socketBaseURL = "wss://bbws.topaz.net.az" // MARK: PROD
    case socketBaseURL = "wss://stbbws.topaz.net.az" // MARK: TEST
    
//    case ssbtBaseURL = "https://tps.topaz.net.az/api/terminal/" // MARK: PROD
    case ssbtBaseURL = "https://sttps.topaz.net.az/api/terminal/" // MARK: TEST
    
//    case paymentBaseURL = "https://payr.topaz.net.az/api/" // MARK: PROD
    case paymentBaseURL = "https://stpayr.topaz.net.az/api/" // MARK: TEST
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

