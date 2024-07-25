//
//  UIViewController+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit

extension UIViewController {
    func isOlderThan18(birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let birthdateComponent = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: Date())
        
        if let userYear = birthdateComponent.year,
           let currentYear = currentDateComponent.year {
            let age = currentYear - userYear
            
            // Check if the user is older than 18
            return age >= 18
        }
        return false
    }
}
