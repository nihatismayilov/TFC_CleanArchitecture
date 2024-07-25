//
//  ErrorResponse.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

class ErrorResponse: Codable {
    let code: String
    let message: String
    
    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}

extension Data {
    func getErrorResponse() -> ErrorResponse {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(ErrorResponse.self, from: self)
        } catch {
            print(error.localizedDescription)
            return ErrorResponse.init(code: "", message: "")
        }
    }
}
