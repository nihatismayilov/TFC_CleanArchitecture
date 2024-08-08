//
//  UITapGestureRecognizer+Extensions.swift
//  presentation
//
//  Created by Rufat  on 08.08.24.
//

import Foundation
import UIKit


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) {
        if let attributedText = label.attributedText {
            
            let mutableString = NSMutableAttributedString(attributedString: attributedText)
            mutableString.addAttributes([.font: label.font!], range: NSRange(location: 0, length: attributedText.length))
            
            let textStorage = NSTextStorage(attributedString: mutableString)
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            
            let textContainer = NSTextContainer(size: label.bounds.size)
            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode
            layoutManager.addTextContainer(textContainer)
            
            let locationOfTouchInLabel = self.location(in: label)
            let textBoundingBox = layoutManager.usedRect(for: textContainer)
            let textContainerOffset = CGPoint(
                x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
            )
            let locationOfTouchInTextContainer = CGPoint(
                x: locationOfTouchInLabel.x - textContainerOffset.x,
                y: locationOfTouchInLabel.y - textContainerOffset.y
            )
            
            let indexOfCharacter = layoutManager.characterIndex(
                for: locationOfTouchInTextContainer,
                in: textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil
            )
            print("Character index >>> \(indexOfCharacter)")
            print("Target range >> \(targetRange)")
            print( NSLocationInRange(indexOfCharacter, targetRange))
        }
    }
}
