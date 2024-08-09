//
//  OtpErrorViewController.swift
//  presentation
//
//  Created by Rufat  on 08.08.24.
//

import UIKit

protocol OtpErrorPopUpClosed : NSObject{
    func otpErrorPopUpClosed()
}

public class OtpErrorViewController: UIViewController {
    // MARK: - Variables
    weak var delegate : OtpErrorPopUpClosed?
    
    // MARK: - UI Components
    private let topLine = UIView(
        backgroundColor: .lightGray,
        cornerRadius: 3
    )
    private let warningContainerView = UIView(
        backgroundColor: .secondaryBorder
    )
    private let warningImageView = UIImageView(
        image: .icWarning,
        backgroundColor: nil
    )
    private let labelStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 16
    )
    private let blockedLabel = UILabel(
        text: "Hesabınız bloklanmışdır!",
        textColor: .black,
        textAlignment: .center,
        font: .systemFont(ofSize: 22,weight: .semibold)
    )
    
    private let descriptionLabel = UILabel(
        textColor: .secondaryText,
        textAlignment: .center,
        font: .systemFont(ofSize: 16,weight: .regular)
    )
    private let supportStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: 12
    )
    
    private let whatsappStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: 12
    )
    
    
    private let supportLogo = UIImageView(
        image: .icSupport,
        tintColor: nil
    )
    
    private let whatsappLogo = UIImageView(
        image: .icWhatsapp,
        tintColor: nil
    )
    
    private let supportLabelStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 2
    )
    
    private let supportNumberLabel = UILabel(
        text: "*926",
        textColor: .black,
        font: .systemFont(ofSize: 16,weight: .medium)
    )
    private let supportText = UILabel(
        text: "Qaynar xətt",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 12,weight: .regular)
    )
    
    private let whatsappTextLabel = UILabel(
        text: "WhatsApp-a yazmaq",
        textColor: .black,
        font: .systemFont(ofSize: 16,weight: .medium)
    )
    
    private let whatsappDescriptionLabel = UILabel(
        text: "Qısa müddət ərzində müraciətinizi cavablayırıq",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 12,weight: .regular)
    )
    
    private let whatsappLabelStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 2
    )
    
    private let closeButton = UIButton(
        title: "Bağla",
        tintColor: .white,
        backgroundColor: .red ,
        cornerRadius: 8
    )
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .background
        closeButton.addTarget(self, action: #selector(didTap(_ :)), for: .touchUpInside)
        addSubviews()
        setText()
        NSLayoutConstraint.activate([
            topLine.heightAnchor.constraint(equalToConstant: 4),
            topLine.widthAnchor.constraint(equalToConstant: 48),
            topLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLine.topAnchor.constraint(equalTo: view.topAnchor,constant: 8),
            
            warningContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningContainerView.topAnchor.constraint(equalTo: topLine.bottomAnchor,constant: 24),
            warningContainerView.heightAnchor.constraint(equalToConstant: 68),
            warningContainerView.widthAnchor.constraint(equalToConstant: 68),
            
            warningImageView.centerXAnchor.constraint(equalTo: warningContainerView.centerXAnchor),
            warningImageView.centerYAnchor.constraint(equalTo: warningContainerView.centerYAnchor),
            warningImageView.widthAnchor.constraint(equalToConstant: 36),
            warningImageView.heightAnchor.constraint(equalToConstant: 36),
            
            supportLogo.heightAnchor.constraint(equalToConstant: 40),
            supportStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            supportStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 37),
            supportStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -248),
            
            whatsappLogo.heightAnchor.constraint(equalToConstant: 40),
            whatsappStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            whatsappStackView.topAnchor.constraint(equalTo: supportStackView.bottomAnchor, constant: 24),
            whatsappStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            whatsappStackView.heightAnchor.constraint(equalToConstant: 40),
            
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelStackView.topAnchor.constraint(equalTo: warningContainerView.bottomAnchor, constant: 24),
//            labelStackView.heightAnchor.constraint(equalToConstant: 140),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            closeButton.topAnchor.constraint(equalTo: whatsappStackView.bottomAnchor, constant: 40),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            closeButton.heightAnchor.constraint(equalToConstant: 48)
            
        ])

    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.otpErrorPopUpClosed()
        
    }
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureWarningView()
    }
    private func setText() {
        let text =  "OTP kodu 3 dəfə yanlış daxil etdiyiniz üçün təhlükəsizlik baxımından hesabınız bloklanmışdır. Hesabınızı yenidən aktivləşdirmək üçün zəhmət olmasa,Dəstək Xətti ilə əlaqə saxlayın."
        let range = (text as NSString).range(of: "Dəstək Xətti")
        let attribute : [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 16,weight: .semibold)]
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes(attribute, range: range)
        descriptionLabel.attributedText = attributedText
    
    }
    private func addSubviews() {
        supportLabelStackView.addArrangedSubviews(supportNumberLabel,supportText)
        whatsappLabelStackView.addArrangedSubviews(whatsappTextLabel,whatsappDescriptionLabel)
        supportStackView.addArrangedSubviews(supportLogo,supportLabelStackView)
        whatsappStackView.addArrangedSubviews(whatsappLogo,whatsappLabelStackView)
        warningImageView.contentMode = .scaleAspectFit
        warningContainerView.clipsToBounds = true
//        warningImageView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubviews(blockedLabel,descriptionLabel)
        warningContainerView.addSubview(warningImageView)
        view.addSubviews(topLine,warningContainerView,labelStackView,supportStackView,whatsappStackView,closeButton)
    }
    
    @objc func didTap(_ sender : UIButton) {
            self.dismiss(animated: true)
//        delegate?.otpErrorPopUpClosed()
    }
    private func configureWarningView() {
        warningContainerView.cornerRadius = warningContainerView.frame.width/2
    }

}
