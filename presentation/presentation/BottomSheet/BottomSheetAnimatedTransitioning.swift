//
//  BottomSheetAnimatedTransitioning.swift
//  presentation
//
//  Created by Rufat  on 05.08.24.
//

import Foundation
import UIKit
class BottomSheetAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        print("I was called")
        let presenter = transitionContext.containerView
        if let presented = transitionContext.view(forKey: .to) {
            presenter.addSubview(presented)
            presented.frame = CGRect(x: 0, y: presenter.frame.height, width: presenter.frame.width, height: 300)
            UIView.transition(with: presented, duration: transitionDuration(using: transitionContext),options: [.beginFromCurrentState,.curveEaseOut],animations: {
                presented.frame.origin.y = presenter.frame.origin.y - 200
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }
        if let presented = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
                presented.frame.origin.y = presenter.frame.origin.y + 5
            } completion: { _ in
                presented.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
    
    
    
    
}
