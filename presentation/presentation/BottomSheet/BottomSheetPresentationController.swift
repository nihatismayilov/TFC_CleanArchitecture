//
//  BottomSheetPresentationController.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

import Foundation
import UIKit

class BottomSheetPresentationController: UIPresentationController {
    
    private let blurEffectView: UIVisualEffectView!
       var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
       var sheetHeight: CGFloat = 200

       override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
           let blurEffect = UIBlurEffect(style: .dark)
           blurEffectView = UIVisualEffectView(effect: blurEffect)
           super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
           tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.blurEffectView.isUserInteractionEnabled = true
           self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
       }

//       override var frameOfPresentedViewInContainerView: CGRect {
//           guard let containerView = containerView else { return .zero }
//           return CGRect(x: 0,
//                         y: containerView.frame.height - sheetHeight,
//                         width: containerView.frame.width,
//                         height: sheetHeight)
//       }

       override func presentationTransitionWillBegin() {
           super.presentationTransitionWillBegin()
           print("beginning")
           guard let presentedView else {return}
           presentedView.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)
           self.blurEffectView.alpha = 0
           containerView?.addSubview(blurEffectView)
           
           presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
               self.blurEffectView.alpha = 0.7
           }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
           
       }
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
        super.presentationTransitionDidEnd(completed)
       
        print("finished")
        guard let presentedView else {return}
//        presentedView.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)
    }

       override func dismissalTransitionWillBegin() {
           presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
               self.blurEffectView.alpha = 0
           }, completion: { (UIViewControllerTransitionCoordinatorContext) in
               self.blurEffectView.removeFromSuperview()
           })
       }

       override func containerViewWillLayoutSubviews() {
           super.containerViewWillLayoutSubviews()
           presentedView?.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)
       }

       override func containerViewDidLayoutSubviews() {
           super.containerViewDidLayoutSubviews()
           blurEffectView.frame = containerView!.bounds
           presentedView?.frame = CGRect(x: 0, y: (containerView?.bounds.height)! - sheetHeight, width: (containerView?.bounds.width)!, height: sheetHeight)

       }

       @objc func dismissController() {
           presentedViewController.dismiss(animated: true, completion: nil)
       }
}
