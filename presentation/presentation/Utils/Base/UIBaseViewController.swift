//
//  UIBaseViewController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit
import Combine

open class UIBaseViewController<VM: BaseViewModel>: UIViewController {
    // MARK: - Variables
    private var cancellables: Set<AnyCancellable> = .init()
    internal let viewModel: VM
    private  var bottomConstraintToHandle : NSLayoutConstraint!
    private  var initialBottomConstraintConstant : CGFloat!
    
    //var isPageInitialized = false
    
    // MARK: - UI Components
    private var loadingView = LoadingView()
    
    // MARK: - Initializations
    init(vm: VM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller delegates
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
        setText()
        setBindings()
        initViews()
        initVars()
        //self.isPageInitialized = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setText()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Handle BottomSheet presentation
//    func presentAsBottomSheet(vc : UIViewController) {
//        vc.transitioningDelegate = vc
//    }
    
    // MARK: - Initializations
    private func setupBase() {
        loadingView.frame = view.frame
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        view.backgroundColor = .background
        
        let loadingSubscription = viewModel.observeLoading().sink { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
        let baseEffectSubscription = self.viewModel.observeBaseEffect().sink { [weak self] effect in
            guard let self else { return }
            observe(baseEffect: effect)
        }
        
        self.addCancellable(loadingSubscription)
        self.addCancellable(baseEffectSubscription)
    }
    
    func setText() { }
    
    func setBindings() { }
    
    func initVars() { }
    
    func initViews() { }
    
    
    // MARK: - KeyboardObserver
    func keyboardShift(_ constraint : NSLayoutConstraint) {
        initialBottomConstraintConstant = constraint.constant
        bottomConstraintToHandle = constraint
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Subscriptions
    @objc fileprivate func didTapOnView(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func observe(baseEffect: BaseEffect) {
        switch baseEffect {
        case .error(let title, let message):

            self.promptAlert(title: title,
                             content: message,
                             actionTitle: "OK") {
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Observe Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let constraint = bottomConstraintToHandle{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                constraint.constant = -(keyboardSize.height)
                UIView.transition(with: view, duration: 0.5, options: .beginFromCurrentState) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let constraint = bottomConstraintToHandle{
            constraint.constant = initialBottomConstraintConstant
            UIView.transition(with: view, duration: 0.5, options: .beginFromCurrentState) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI
    func addCancellable(_ cancellable: AnyCancellable) {
        cancellable.store(in: &self.cancellables)
    }
        
    func startAnimating() {
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
    }

    func stopAnimating() {
        loadingView.removeFromSuperview()
    }
    
    func promptAlert(title: String,
                     content: String,
                     actionTitle: String,
                     onAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
        let actionBtn = UIAlertAction(title: actionTitle, style: .default, handler: { action in
            onAction()
        })
        actionBtn.setValue(UIColor.red600, forKey: "titleTextColor")

        alert.addAction(actionBtn)
        self.present(alert, animated: true)
    }
    
    func promptAlert(title: String,
                     content: String,
                     positiveActionTitle: String,
                     negativeActionTitle: String,
                     onPositiveAction: @escaping () -> Void,
                     onNegativeAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
        let actionPositiveBtn = UIAlertAction(title: positiveActionTitle, style: .default, handler: { action in
            onPositiveAction()
        })
        actionPositiveBtn.setValue(UIColor.red600, forKey: "titleTextColor")

        alert.addAction(actionPositiveBtn)
        
        let actionNegativeBtn = UIAlertAction(title: negativeActionTitle, style: .cancel, handler: { action in
            onNegativeAction()
        })
        actionNegativeBtn.setValue(UIColor.red600, forKey: "titleTextColor")

        alert.addAction(actionNegativeBtn)
        
        alert.preferredAction = actionPositiveBtn
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    func pushNavigation(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearStack() {
        if let vcs = self.navigationController?.viewControllers {
            self.navigationController?.viewControllers.removeSubrange(0..<vcs.count-1)
        }
    }
    
    // MARK: - Conformance to TransitioningDelegate
}
