//
//  ForceUpdateVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit

class ForceUpdateVC: UIBaseViewController<BaseViewModel> {
    // MARK: - UI Components
    private lazy var topImageView = UIImageView(image: .icForceUpdate)
    
    private lazy var mainStackView = UIStackView(
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 36)
    
    private lazy var logoImageView = UIImageView(image: .icTfcLogo)
    
    private lazy var labelStackView = UIStackView(axis: .vertical, spacing: 8)
    
    private lazy var forceTitleLabel = UILabel(
        text: "Tətbiqin yenilənməsi mövcuddur.",
        textColor: .primaryText,
        textAlignment: .center,
        font: .systemFont(ofSize: 20, weight: .semibold)
    )
    
    private lazy var forceDescriptionLabel = UILabel(
        text: "Zəhmət olmasa tətbiqi yeniləyin.",
        textColor: .secondaryText,
        textAlignment: .center,
        font: .systemFont(ofSize: 16)
    )
    
    private lazy var updateButton = BaseButton(
        title: "Yeniləyin",
        tintColor: .white,
        backgroundColor: .red600,
        cornerRadius: 8
    )
    
    // MARK: - Controller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initViews() {
        view.addSubviews(topImageView, mainStackView, labelStackView, updateButton)
        mainStackView.addArrangedSubviews(logoImageView, labelStackView)
        labelStackView.addArrangedSubviews(forceTitleLabel, forceDescriptionLabel)
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            updateButton.heightAnchor.constraint(equalToConstant: 48),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
    }
    
    @objc func updateTapped() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1581746881"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
