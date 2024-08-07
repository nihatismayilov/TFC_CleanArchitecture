//
//  BottomSheetTransitioningDelegate.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

import Foundation
import UIKit

enum BottomSheetHeight {
    case automatic
    case custom(height : CGFloat)
}

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
//    var closePresentingVc = false
    var sheetHeight: BottomSheetHeight = .automatic
    
    init(sheetHeight: BottomSheetHeight = .automatic) {
        self.sheetHeight = sheetHeight
//        self.closePresentingVc = closePresentingVc
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
//        presentationController.closePresentingVc = closePresentingVc
        presentationController.sheetHeight = switch sheetHeight {
        case .automatic:
            242
        case .custom(let height):
            height
        }
        return presentationController
    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
//        return nil
//    }
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
//        return nil
//    }
}
