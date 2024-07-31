//
//  OtpView.swift
//  presentation
//
//  Created by Nihad Ismayilov on 30.07.24.
//

import UIKit

protocol CheckOtp{
    func checkOtp(countOfOtp : Int)
    func handleWarningLabel()
}

class OTPView: UIView {
    var isAfterWrongOtp: Bool = false
    var delegate: CheckOtp?
    var otpString: String = ""
    
    var textFields = [UITextField]()
    var lines = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<6 {
            let textField = createTextField()
            textField.tag = i
            textField.delegate = self
            textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            textFields.append(textField)
            let line = createLine()
            lines.append(line)
            addSubview(line)
        }
        // Layout the text fields and lines
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for (index, textField) in textFields.enumerated() {
            let line = lines[index]
            textFields[index].translatesAutoresizingMaskIntoConstraints = false
            line.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textFields[index].widthAnchor.constraint(equalToConstant: 32),
                
                line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6),
                line.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
                line.widthAnchor.constraint(equalToConstant: 32),
                line.heightAnchor.constraint(equalToConstant: 4)
            ])
        }
        textFields.first?.becomeFirstResponder()
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.borderStyle = .none
        return textField
    }
    
    private func createLine() -> UIView {
        let line = UIView()
        line.backgroundColor = .tertiary
        line.layer.cornerRadius = 1
        return line
    }
    
    func getOTPCode() -> String {
        return textFields.compactMap { $0.text }.joined()
    }
}

extension OTPView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        if textField.text?.count == 1, string != "" {
            let nextTag = textField.tag + 1
            if nextTag < textFields.count {
                textFields[nextTag].text = string
                lines[nextTag].backgroundColor = .primaryText
                if nextTag + 1 < textFields.count {
                    textFields[nextTag + 1].becomeFirstResponder()
                } else {
                    textFields[textField.tag].resignFirstResponder()
                }
                return false
            }
        }
        
        if string.isEmpty, range.length == 1, currentText.isEmpty {
            let previousTag = textField.tag - 1
            if previousTag >= 0 {
                textFields[previousTag].becomeFirstResponder()
                textFields[previousTag].text = ""
                lines[previousTag].backgroundColor = .tertiary
            }
            return false
        }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 1
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count <= 1 else { return }
        
        if text.count == 1 {
            if isAfterWrongOtp {
                if textField == textFields.first {
                    if getOTPCode().count == 1 {
                        lines.forEach { $0.backgroundColor = .tertiary }
                    }
                    isAfterWrongOtp = true
                    delegate?.handleWarningLabel()
                }
            }
            
            let nextTag = textField.tag + 1
            if nextTag < textFields.count {
                textFields[nextTag].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            lines[textField.tag].backgroundColor = .primaryText
        } else {
            lines[textField.tag].backgroundColor = .tertiary
            let previousTag = textField.tag - 1
            if previousTag >= 0 {
                textFields[previousTag].becomeFirstResponder()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.checkOtp(countOfOtp: self.getOTPCode().count)
    }
}
