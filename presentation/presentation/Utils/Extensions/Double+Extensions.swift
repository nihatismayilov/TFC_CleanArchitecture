//
//  Double+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 30.07.24.
//

import Foundation

extension Double {
    func toMinuteSecondsString() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
