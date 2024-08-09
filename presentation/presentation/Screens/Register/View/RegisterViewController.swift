//
//  RegisterVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 24.07.24.
//

import UIKit

public class RegisterViewController: UIBaseViewController<RegisterViewModel> {
    // MARK: - Variable
    private var bottomConstraint : NSLayoutConstraint?
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
        distribution: .fill,
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
    private lazy var errorLabel = UILabel(
        text: "Düzgün prefiksi daxil edin",
        textColor: .red600,
        textAlignment: .left,
        font: .systemFont(ofSize: 12, weight: .medium)
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
        cornerRadius: 8,
        isEnabled: false
    )
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let bottomConstraint else{return}
        observeKeyboard(constraint: bottomConstraint)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubviews(
            closeButton,
            labelStackView,
            phoneNumberStackView,
            errorLabel,
            termsConditionsLabel,
            sendButton
        )
        bottomConstraint = sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        guard let bottomConstraint else{return}
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
            phoneNumberStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            errorLabel.topAnchor.constraint(equalTo: phoneNumberStackView.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: phoneNumberStackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: phoneNumberStackView.trailingAnchor),
            
            termsConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsConditionsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            termsConditionsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            termsConditionsLabel.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -24),
            
            sendButton.heightAnchor.constraint(equalToConstant: 48),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bottomConstraint
            
        ])
        phoneTextField.keyboardType = .numberPad
        errorLabel.isHidden = true
        phoneTextField.delegate = self
        closeButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    override func setText() {
        termsConditionsLabel.attributedText = "Qeydiyyatdan keçdikdə siz Şərtlər və Qaydaları və Gizlilik Siyasətini qəbul edirsiniz.".colorAttributedString(strings: ["Şərtlər və Qaydaları", "Gizlilik Siyasətini"], color: .red600)
    }
    
    override func setBindings() {
        let registerSubscription = viewModel.observeRegister()
            .sink { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    pushNavigation(Router.getOtpVC(phoneNumber: "994\(phoneTextField.text.orEmpty)".trim()))
                }
            }
        addCancellable(registerSubscription)
    }
    
    // MARK: - Functions
    @objc func didTap(_ sender: UIButton) {
        switch sender {
        case closeButton:
            dismiss(animated: true)
        case sendButton:
            viewModel.register(by: phoneTextField.text)
        default: break
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        phoneTextField.text = textField.text?.format(with: "XX XXX XX XX")
        
        let prefix = phoneTextField.text?.prefix(2) ?? ""
        errorLabel.isHidden = viewModel.checkIndex(prefix: String(prefix))
        sendButton.isEnabled = viewModel.checkIndex(prefix: String(prefix)) && phoneTextField.text?.trim().count == 9
    }
}
