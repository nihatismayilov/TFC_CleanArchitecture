//
//  InputView.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import UIKit

enum InputViewType {
    case name
    case phone
    case birthday
    case dropdown
    case amount
    case search
    case number
}

protocol InputViewDelegate: NSObject {
    func shouldChangeSelection(textField: InputView, range: NSRange, string: String) -> Bool
    func textFieldShouldBeginEditing(_ textField: InputView) -> Bool
    func textFieldDidBeginEditing(_ textField: InputView)
    func textFieldShouldEndEditing(_ textField: InputView) -> Bool
    func textFieldDidEndEditing(_ textField: InputView)
    func textFieldDidEndEditing(_ textField: InputView, reason: UITextField.DidEndEditingReason)
    func textFieldDidChangeSelection(_ textField: InputView, string: String)
    func textFieldShouldClear(_ textField: InputView) -> Bool
    func textFieldShouldReturn(_ textField: InputView) -> Bool
    func didTapTextField(textField: InputView)
    func didTapRightIcon()
}

extension InputViewDelegate {
    func shouldChangeSelection(textField: InputView, range: NSRange, string: String) -> Bool {true}
    func textFieldShouldBeginEditing(_ textField: InputView) -> Bool {true}
    func textFieldDidBeginEditing(_ textField: InputView) {}
    func textFieldShouldEndEditing(_ textField: InputView) -> Bool {true}
    func textFieldDidEndEditing(_ textField: InputView) {}
    func textFieldDidEndEditing(_ textField: InputView, reason: UITextField.DidEndEditingReason) {}
    func textFieldDidChangeSelection(_ textField: InputView,string: String) {}
    func textFieldShouldClear(_ textField: InputView) -> Bool {true}
    func textFieldShouldReturn(_ textField: InputView) -> Bool {true}
    func didTapTextField(textField: InputView) {}
    func didTapRightIcon() {}
}
class InputView: UIView {
    // MARK: - Variables
    weak var delegate: InputViewDelegate?
    var isActive: Bool = false
    var hasError: Bool = false
    private var _hasRightIcon: Bool = false
    var isDropdownShown = false
    var rightImage: UIImage = UIImage(systemName: "chevron.down")! {
        didSet {
            rightButton.setImage(rightImage, for: .normal)
        }
    }
    
    @IBInspectable
    var text: String {
        get {
            return textField.text.orEmpty
        } set {
            textField.text = newValue
        }
    }
    
    @IBInspectable
    var titleText: String? {
        get {
            titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable
    var hasRightIcon: Bool {
        get {
            _hasRightIcon
        } set {
            _hasRightIcon = newValue
            rightButton.isHidden = !_hasRightIcon
        }
    }
    
    @IBInspectable
    var placeHolder: String?{
        get{
            textField.attributedPlaceholder?.string
        } set{
            let attributedString = NSAttributedString(string: newValue ?? "", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.secondaryText
            ])
            textField.attributedPlaceholder = attributedString
        }
    }
    
    var type: InputViewType = .name{
        didSet{
            updateType()
        }
    }
    
    // MARK: - UI Components
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        titleView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryText
        label.font = .systemFont(ofSize: 12)
        label.text = "Title"
        return label
    }()
    private lazy var textFieldBack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryBackground
        view.cornerRadius = 8
        view.borderWidth = 1
        view.borderColor = .secondaryBorder
        
        return view
    }()
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        textFieldBack.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = .systemFont(ofSize: 16, weight: .medium)
        tf.placeholder = "Placeholder"
        return tf
    }()
    private lazy var leftIcon  : UIImageView = {
        let imageView = UIImageView(image: UIImage.icSearch,
                                    tintColor: .secondaryText)
        imageView.isHidden = true
        return imageView
    
    }()
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = false
        button.tintColor = .secondaryText
//        button.contentVerticalAlignment = .center
//        button.contentHorizontalAlignment = .center
//        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private lazy var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "+994"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        errorView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red600
        label.font = .systemFont(ofSize: 12)
        label.text = "Error message"
        return label
    }()
    
    func becomeResponder() {
        textField.becomeFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubviews(titleView, textFieldBack, errorView)
        textStackView.addArrangedSubviews(phoneTitleLabel, leftIcon,textField, rightButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            
            leftIcon.widthAnchor.constraint(equalToConstant: 20),
            leftIcon.heightAnchor.constraint(equalToConstant: 20),
            textField.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor,constant: 8),
            
            textFieldBack.heightAnchor.constraint(equalToConstant: 48),
            textStackView.centerYAnchor.constraint(equalTo: textFieldBack.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: textFieldBack.leadingAnchor, constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: textFieldBack.trailingAnchor, constant: -12),
            
            rightButton.heightAnchor.constraint(equalToConstant: 24),
            rightButton.widthAnchor.constraint(equalToConstant: 24),
            textField.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: -20),
            
            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 2),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -16),
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -2)
        ])
        errorView.isHidden = true
        textFieldBack.backgroundColor = .secondaryBackground
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapTextField(textField: self)
    }
    @objc func rightIconTapped(_ sender : UIButton) {
        delegate?.didTapRightIcon()
    }
    
    func showError(text: String) {
        hasError = true
        errorLabel.text = text
        errorView.isHidden = text.isEmpty
        UIView.transition(with: self, duration: 0.25, options: [.beginFromCurrentState, .curveEaseInOut]) { [weak self] in
            guard let self else {return}
            textFieldBack.backgroundColor = UIColor.red600.withAlphaComponent(0.10)
            textFieldBack.borderColor = .red600
            titleLabel.textColor = .red600
        }
    }
    func hideError() {
        hasError = false
        errorView.isHidden = true
        UIView.transition(with: self, duration: 0.25, options: [.beginFromCurrentState, .curveEaseInOut]) { [weak self] in
            guard let self else {return}
            textFieldBack.backgroundColor = .secondaryBackground
            textFieldBack.borderColor = .secondaryBorder
            titleLabel.textColor = .secondaryText
        }
    }
    
    private func becomeActive() {
        isActive = true
        UIView.transition(with: self, duration: 0.3, options: .beginFromCurrentState) { [weak self] in
            guard let self else {return}
            let colorProvider = UIColor { [unowned self] trait in
                let trColor = UIColor.primaryText.resolvedColor(with: trait)
                self.textFieldBack.layer.borderColor = trColor.cgColor
                return trColor
            }
            tintColor = colorProvider
        }
    }
    private func becomeDeactive() {
        isActive = false
        UIView.transition(with: self, duration: 0.3, options: .beginFromCurrentState) { [weak self] in
            guard let self else {return}
            let colorProvider = UIColor { trait in
                let trColor = UIColor.secondaryBorder.resolvedColor(with: trait)
                self.textFieldBack.layer.borderColor = trColor.cgColor
                return trColor
            }
            tintColor = colorProvider
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard hasError == false else { return }
        if traitCollection.userInterfaceStyle == .dark {
            if isActive {
                textFieldBack.borderColor = .neutral1
            } else {
                textFieldBack.borderColor = .secondaryBorder
            }
        } else {
            if isActive {
                textFieldBack.borderColor = .neutral900
            } else {
                textFieldBack.borderColor = .secondaryBorder
            }
        }
    }
    
    private func updateType() {
        switch type {
        case .name:
            textField.isEnabled = true
            textField.textContentType = .name
            textField.keyboardType = .default
            phoneTitleLabel.isHidden = true
        case .phone:
            textField.isEnabled = true
            textField.textContentType = .telephoneNumber
            textField.keyboardType = .numberPad
            phoneTitleLabel.isHidden = false
        case .birthday:
            textField.isEnabled = true
            textField.inputView = datePicker
            phoneTitleLabel.isHidden = true
            rightButton.addTarget(self, action: #selector(rightIconTapped(_ :)), for: .touchUpInside)
        case .dropdown:
            let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            textFieldBack.addGestureRecognizer(tap)
            textField.isEnabled = false
            rightButton.setImage(UIImage(systemName: "chevron.down")!, for: .normal)
            phoneTitleLabel.isHidden = true
            rightButton.isEnabled = false
        case .amount:
            textField.isEnabled = true
            textField.keyboardType = .numberPad
            rightButton.setImage(UIImage(systemName: "manatsign"), for: .normal)
            phoneTitleLabel.isHidden = true
        case .search:
            textField.isEnabled = true
            textField.keyboardType = .default
            leftIcon.isHidden = false
            phoneTitleLabel.isHidden = true
            rightButton.isHidden = true
        case .number:
            textField.isEnabled = true
            textField.keyboardType = .numberPad
            rightButton.isHidden = true
            phoneTitleLabel.isHidden = true
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        textField.text = dateFormatter.string(from: sender.date)
        delegate?.textFieldDidChangeSelection(self, string: textField.text!)
    }
}

extension InputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing(self) ?? true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        becomeActive()
        if type == .dropdown {
            endEditing(true)
            delegate?.didTapTextField(textField: self)
            return
        }
//        hideError()
        delegate?.textFieldDidBeginEditing(self)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldEndEditing(self) ?? true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        becomeDeactive()
        delegate?.textFieldDidEndEditing(self)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        becomeDeactive()
        delegate?.textFieldDidEndEditing(self, reason: reason)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.shouldChangeSelection(textField: self, range: range, string: string) ?? true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChangeSelection(self, string: textField.text.orEmpty)
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldClear(self) ?? true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }
}

