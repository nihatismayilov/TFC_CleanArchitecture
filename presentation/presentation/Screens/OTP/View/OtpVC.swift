//
//  OtpVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 24.07.24.
//

import UIKit

class OtpVC: UIBaseViewController<BaseViewModel> {
    // MARK: - UI Components
    
    // MARK: - Controller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initializations
    override func initViews() {
        setNavigationButton()
    }
    
    private func setNavigationButton() {
        navigationController?.navigationBar.isHidden = false
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")!,
            style: .plain,
            target: self,
            action: #selector(didTap)
        )
        button.tintColor = .primaryText
        navigationItem.leftBarButtonItems = [button]
    }
    
    @objc func didTap(_ sender: UIButton) {
        switch sender {
        case navigationItem.leftBarButtonItem:
            navigationController?.popViewController(animated: true)
        default: break
        }
    }
}
