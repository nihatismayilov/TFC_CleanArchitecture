//
//  BottomSheetTransitioningDelegate.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

import Foundation
import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var sheetHeight: CGFloat = 242
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.sheetHeight = sheetHeight
            return presentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return nil
    }
}
