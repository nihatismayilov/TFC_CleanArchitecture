//
//  BottomSheetPresentationController.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

import Foundation
import UIKit

class BottomSheetPresentationController: UIPresentationController {
//    var isDraggingUpwardAllowed : Bool = false
//    var closePresentingVc = false
    private let blurEffectView: UIVisualEffectView!
    private var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var sheetHeight  = 0.0
    private var dragGesture : UIPanGestureRecognizer = UIPanGestureRecognizer()
    private var initialTouch  = 0.0
    private var initialYpoint = 0.0
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_ :)))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.presentedView?.addGestureRecognizer(dragGesture)
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        self.blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.8
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
//        self.setHeight()
    }
    //    override func presentationTransitionDidEnd(_ completed: Bool) {
    //        super.presentationTransitionDidEnd(completed)
    //        presentedView.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)
    //    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        blurEffectView.removeGestureRecognizer(tapGestureRecognizer)
        
    }
    private func setHeight() {
        guard let presentedView , let containerView else{return}
        let targetSize = CGSize(width: containerView.bounds.width, height: sheetHeight)
        let optimalHeight = presentedView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .dragThatCannotResizeScene).height
        self.sheetHeight = optimalHeight
        presentedView.frame = CGRect(x: 0, y: (containerView.bounds.height - sheetHeight), width: containerView.bounds.width, height: sheetHeight )
    }
    //       override func containerViewWillLayoutSubviews() {
    //           super.containerViewWillLayoutSubviews()
    //           presentedView?.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)
    //       }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presentedView else{return}
        blurEffectView.frame = containerView!.bounds
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        presentedView.layer.cornerRadius = 15
        self.setHeight()
    }
    
    @objc func handleDrag(_ sender : UIPanGestureRecognizer) {
        guard let containerView, let presentedView else {return}
        let yOffset = sender.location(in: containerView).y
        let difference = calculateDiffernce(yOffset: yOffset)
        switch sender.state {
        case .began :
            initialTouch = yOffset
            initialYpoint = presentedView.frame.origin.y
        case .changed :
            if difference < 0 {
                presentedView.frame.origin.y = initialYpoint - difference
                print("difference >>> \(yOffset)")
            }
        case .ended :
            if difference < -100 {
//                if closePresentingVc {
//                    presentingViewController.dismiss(animated: true)
//                    presentedViewController.dismiss(animated: true)
//                }else{
                    presentedViewController.dismiss(animated: true)
                }else  {
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.setHeight()
                }
            }
        default :
            break
        }
    }
    
    private func calculateDiffernce(yOffset : CGFloat) -> CGFloat {
        return (initialTouch - yOffset)
    }
    
    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
