//
//  Int+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 07.08.24.
//

import Foundation

extension Int? {
    var orZero: Int {
        self ?? 0
    }
    var isNilOrZero: Bool {
        self == nil || self == 0
    }
}
