//
//  TestLocalDTO.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

// For CoreData
class TestLocalDTO {
    @objc dynamic var id: String = ""
    @objc dynamic var test: String = ""
    
    func setData(
        id: String,
        test: String
    ) {
        self.id = id
        self.test = test
    }
}
