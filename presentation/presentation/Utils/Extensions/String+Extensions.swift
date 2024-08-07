//
//  String+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 24.07.24.
//

import UIKit

extension String? {
    var orEmpty: String {
        self ?? ""
    }
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}

extension String {
    func containsNumber() -> Bool {
            let numberRegex = ".*[0-9].*"
            let containsNumberRegex = self.range(of: numberRegex, options: .regularExpression) != nil
            return containsNumberRegex
        }

    func format(with mask: String) -> String {
        let numbers = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func trim() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    func colorAttributedString(strings: [String], color: UIColor) -> NSAttributedString {
        // Create a mutable attributed string
        let attributedString = NSMutableAttributedString(string: self)
        
        // Define the color attribute
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        
        // Apply the attributes to the specified substrings
        for substring in strings {
            let ranges = self.ranges(of: substring)
            for range in ranges {
                let nsRange = NSRange(range, in: self)
                attributedString.addAttributes(attributes, range: nsRange)
            }
        }
        
        return attributedString
    }
    
    // Extension to find all ranges of a substring within a string
    func ranges(of substring: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex,
              let range = self.range(of: substring, range: startIndex..<self.endIndex) {
            ranges.append(range)
            startIndex = range.upperBound
        }
        
        return ranges
    }
    
    func getTextWidth(with font : UIFont) -> CGFloat {
        let attribute = [NSAttributedString.Key.font : font]
        let width = self.size(withAttributes: attribute).width
        return width
    }
    
    func convertDate(to toFormat: String) -> Self {
        let formatTypes: [DateFormats] = DateFormats.allCases
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "az_AZ")
        let currentFormat = formatTypes.first { format in
            formatter.dateFormat = format.rawValue
            guard formatter.date(from: self) != nil else { return false }
            return true
        }
        
        guard !currentFormat.isNil else { return "-" }
        guard let date = formatter.date(from: self) else { return "-" }
        formatter.dateFormat = toFormat
        
        return formatter.string(from: date)
    }
    
    func convertToDate() -> Date? {
        let formatTypes: [DateFormats] = DateFormats.allCases
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "az_AZ")
        let currentFormat = formatTypes.first { format in
            formatter.dateFormat = format.rawValue
            guard formatter.date(from: self) != nil else { return false }
            return true
        }
        
        guard !currentFormat.isNil else { return nil }
        guard let date = formatter.date(from: self) else { return nil }
        return date
    }
}

enum DateFormats: String, CaseIterable {
    case withSlashFormat = "dd/MM/yyyy"
    case mainDateFormat = "yyyy-MM-dd"
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
