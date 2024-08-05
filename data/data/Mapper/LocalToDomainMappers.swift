//
//  LocalToDomainMappers.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

//extension TestLocalDTO {
//    func toDomain() -> Test {
//        return Test(
//            id: self.id,
//            test: self.test
//        )
//    }
//}

extension TokenRemoteDTO {
    func toDomain() -> Token {
        let isSuccess = refreshToken?.isEmpty == false &&
                        token?.isEmpty == false &&
                        checkToken?.isEmpty == false
        return Token(
            isSuccess: isSuccess,
            message: message.orEmpty
        )
    }
}
