//
//  RegisterVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 24.07.24.
//

import UIKit

class RegisterVC: UIBaseViewController<RegisterVM> {
    // MARK: - UI Components
    private lazy var closeButton = BaseButton(
        image: UIImage(systemName: "xmark"),
        title: "",
        tintColor: .primaryText,
        backgroundColor: .clear
    )
    private lazy var labelStackView = UIStackView(
        axis: .vertical,
        spacing: 8
    )
    private lazy var titleLabel = UILabel(
        text: "Mobil nömrənizi daxil edin",
        textColor: .primaryText,
        font: .systemFont(ofSize: 24, weight: .semibold)
    )
    private lazy var descriptionLabel = UILabel(
        text: "Həmin nömrəyə sms kod göndəriləcək",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    private lazy var phoneNumberStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 6
    )
    private lazy var phoneHeaderLabel = UILabel(
        text: "+994",
        textColor: .primaryText,
        font: .systemFont(ofSize: 20, weight: .medium)
    )
    private lazy var phoneTextField = UITextField(
        placeholder: "Mobil nömrə",
        textColor: .primaryText,
        font: .systemFont(ofSize: 20, weight: .medium),
        adjustsFontSize: false
    )
    
    private lazy var termsConditionsLabel = UILabel(
        text: "Qeydiyyatdan keçdikdə siz Şərtlər və Qaydaları və Gizlilik Siyasətini qəbul edirsiniz.",
        textColor: .secondaryText,
        textAlignment: .center,
        numberOfLines: 0,
        font: .systemFont(ofSize: 12)
    )
    
    private lazy var sendButton = BaseButton(
        title: "SMS göndər",
        tintColor: .white,
        backgroundColor: .red600,
        cornerRadius: 8
    )
    
    // MARK: - Controller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubviews(
            closeButton,
            labelStackView,
            phoneNumberStackView,
            termsConditionsLabel,
            sendButton
        )
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        phoneNumberStackView.addArrangedSubviews(phoneHeaderLabel, phoneTextField)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            labelStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            phoneNumberStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 36),
            phoneNumberStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            phoneNumberStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -12),
            
            termsConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsConditionsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            termsConditionsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            termsConditionsLabel.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -24),
            
            sendButton.heightAnchor.constraint(equalToConstant: 48),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        
        phoneTextField.delegate = self
        closeButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    override func setText() {
        termsConditionsLabel.attributedText = "Qeydiyyatdan keçdikdə siz Şərtlər və Qaydaları və Gizlilik Siyasətini qəbul edirsiniz.".colorAttributedString(strings: ["Şərtlər və Qaydaları", "Gizlilik Siyasətini"], color: .red600)
    }
    
    @objc func didTap(_ sender: UIButton) {
        switch sender {
        case closeButton:
            dismiss(animated: true)
        case sendButton:
            print("nt testing",  viewModel.registerSuccess)
            viewModel.register(by: "994993334696")
//            navigationController?.pushViewController(Router.getOtpVC(), animated: true)
//            pushNavigation(Router.getOtpVC())
        default: break
        }
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        phoneTextField.text = textField.text?.format(with: "XX XXX XX XX")
    }
}
