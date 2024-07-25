//
//  LocalToDomainMappers.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation
import domain

extension TestLocalDTO {
    func toDomain() -> Test {
        return Test(
            id: self.id,
            test: self.test
        )
    }
}
