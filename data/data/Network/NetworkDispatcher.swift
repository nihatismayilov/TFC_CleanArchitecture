//
//  NetworkDispatcher.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import Alamofire
import domain

protocol Dispatcher {
    func request<I: Encodable, O: Decodable>(
        baseUrl: BaseURL,
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        params: I?,
        encoder: ParameterEncoder
//        encoding: ParameterEncoding
    ) async throws -> O?
}

class NetworkDispatcher: Dispatcher {
    // MARK: - Variables
    private let session: Session
    private let logger: Logger


    // MARK: - Contructor
    init(
        requestAdapter: [RequestAdapter],
        requestRetriers: [RequestRetrier],
        logger: Logger,
        networkLogger: NetworkLogger
    ) {
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: requestAdapter,
                retriers: requestRetriers
            ),
            eventMonitors: [networkLogger]
        )
    }

    // MARK: - Functions

    func getThrowableError(message: String) -> NSError {
        let throwableError = NSError(domain: "", code: 100, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
        return throwableError
    }

    func request<I: Encodable, O: Decodable>(
        baseUrl: BaseURL,
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        params: I?,
//        encoding: ParameterEncoding
        encoder: ParameterEncoder
    ) async throws -> O? {
        let response = await self.session.request(
            "\(baseUrl.rawValue)\(endpoint)",
            method: method,
            parameters: params,
//            encoder: JSONEncoding.default,
//            encoding: encoding,
            headers: headers
        ).serializingDecodable(O.self).response

        guard response.response?.statusCode != 401 else {
            throw UnauthorizedError()
        }
        
        guard response.response?.statusCode != 204 else {
            return true as? O
        }

        return try response.result.mapError { afError in
            self.logger.logDebug(afError.localizedDescription)

            guard let resErr = response.data?.getErrorResponse()
            else { return afError as Error }

            let uiErrType = UIErrorType(rawValue: resErr.code) ?? .unknown
            return UIError(type: uiErrType) as Error
        }.get()
    }
}
