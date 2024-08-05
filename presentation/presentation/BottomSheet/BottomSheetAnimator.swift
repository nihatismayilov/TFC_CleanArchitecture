//
//  BottomSheetAnimator.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

//import Foundation
//import UIKit
//
//class BottomSheetAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    private let isPresenting: Bool
//    
//    init(isPresenting: Bool) {
//        self.isPresenting = isPresenting
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.3
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let presentedView = transitionContext.view(forKey: isPresenting ? .to : .from) else {
//            return
//        }
//        
//        let containerView = transitionContext.containerView
//        let height: CGFloat = 300
//        let initialFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: height)
//        let finalFrame = CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
//        
//        if isPresenting {
//            presentedView.frame = initialFrame
//            containerView.addSubview(presentedView)
//        }
//        
//        let duration = transitionDuration(using: transitionContext)
//        UIView.animate(withDuration: duration, animations: {
//            presentedView.frame = self.isPresenting ? finalFrame : initialFrame
//        }, completion: { finished in
//            transitionContext.completeTransition(finished)
//        })
//    }
//}
