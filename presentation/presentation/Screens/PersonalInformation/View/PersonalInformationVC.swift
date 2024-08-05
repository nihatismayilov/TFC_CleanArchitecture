//
//  PersonalInformationVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 26.07.24.
//

import UIKit

public class PersonalInformationVC: UIBaseViewController<BaseViewModel> {
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private lazy var scrollStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 32
    )
    
    private lazy var labelStackView = UIStackView(axis: .vertical, spacing: 8)
    
    private lazy var titleLabel = UILabel(
        text: "Şəxsi məlumat",
        textColor: .primaryText,
        font: .systemFont(ofSize: 24, weight: .semibold)
    )
    
    private lazy var descriptionLabel = UILabel(
        text: "Şəxsi profil məlumatlarını dolduraraq qeydiyyatı tamamlayın.",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    
    private lazy var fieldStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: 24
    )
    
    private lazy var nameInputView: InputView = {
        let view = InputView()
        view.type = .name
        view.delegate = self
        view.placeHolder = "Ad"
        
        return view
    }()
    
    private lazy var surnameInputView: InputView = {
        let view = InputView()
        view.type = .name
        view.delegate = self
        view.placeHolder = "Soyad"
        
        return view
    }()
    
    private lazy var nicknameInputView: InputView = {
        let view = InputView()
        view.type = .name
        view.delegate = self
        view.placeHolder = "Ləqəb"
        
        return view
    }()
    
    private lazy var cityInputView: InputView = {
        let view = InputView()
        view.type = .dropdown
        view.delegate = self
        view.placeHolder = "Şəhər"
        
        return view
    }()
    
    private lazy var districtInputView: InputView = {
        let view = InputView()
        view.type = .dropdown
        view.delegate = self
        view.placeHolder = "Rayon"
        
        return view
    }()
    
    private lazy var dobInputView: InputView = {
        let view = InputView()
        view.rightImage = .icInfo
        view.type = .birthday
        view.delegate = self
        view.placeHolder = "GG/AA/İİİİ"
        
        return view
    }()
    
    private lazy var attentionLabel = UILabel(
        text: "Diqqət: Daxil etdiyiniz məlumatlar sonradan yalnız Müştəri Xidmətləri ilə əlaqə saxlanılaraq dəyişdirilə bilər",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    
    private lazy var confirmButton = BaseButton(
        title: "Tamamla",
        tintColor: .neutral1,
        backgroundColor: .red600,
        cornerRadius: 8
    )
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initializations
    override func initViews() {
        setNavigationButton()
        view.addSubviews(scrollView, attentionLabel, confirmButton)
        scrollView.addSubview(scrollStackView)
        scrollStackView.addArrangedSubviews(labelStackView, fieldStackView)
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        fieldStackView.addArrangedSubviews(nameInputView, surnameInputView, nicknameInputView, cityInputView, districtInputView, dobInputView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: attentionLabel.topAnchor, constant: -12),
            
            scrollStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            attentionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            attentionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            attentionLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func setText() {
        attentionLabel.attributedText = "Diqqət: Daxil etdiyiniz məlumatlar sonradan yalnız Müştəri Xidmətləri ilə əlaqə saxlanılaraq dəyişdirilə bilər".colorAttributedString(strings: ["Diqqət:"], color: .red600)
    }
    
    private func setNavigationButton() {
        navigationController?.navigationBar.isHidden = true
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")!,
            style: .plain,
            target: self,
            action: nil
        )
        button.tintColor = .primaryText
        navigationItem.leftBarButtonItems = [button]
    }
}

extension PersonalInformationVC: InputViewDelegate {
    
}
