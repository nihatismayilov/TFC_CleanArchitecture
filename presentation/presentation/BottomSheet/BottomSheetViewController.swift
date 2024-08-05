//
//  BottomSheetViewController.swift
//  presentation
//
//  Created by Rufat  on 04.08.24.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private let topView = UIView(
        backgroundColor: .clear
    )
    private let warningLabel  = UILabel(text: "Xəbərdarlıq", 
                                        textColor: .black ,
                                        textAlignment: .center,
                                        font: .systemFont(ofSize: 18, weight: .semibold))
    let rightButton = UIButton(
        image: UIImage(systemName: "xmark"),
        tintColor: .black
    )
    private var stackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: 12
    )
    private let descLabel = UILabel(
        text: "18 yaşından kiçik şəxslərin idman mərc oyunlarında iştirak etməsi qadağandır!",
        textColor: .black ,
        textAlignment: .center,
        font: .systemFont(ofSize: 14, weight: .medium)
    )
    private var eighteenPlusIcon  = UIImageView(image: UIImage.icEighteenPlus)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        rightButton.addTarget(self, action: #selector(didTapDismiss(_ :)), for: .touchUpInside)
        view.addSubviews(stackView,topView)
        topView.addSubviews(warningLabel, rightButton)
        stackView.addArrangedSubviews(eighteenPlusIcon,descLabel)
        NSLayoutConstraint.activate([
            //TopView Constraints
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            //RightButton Constraints
            rightButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 24),
            rightButton.widthAnchor.constraint(equalToConstant: 24),
            rightButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            //WarningLabel Constraints
            warningLabel.topAnchor.constraint(equalTo: topView.topAnchor,constant: 1),
            warningLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant:  -1),
            warningLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -108),
            //StackView Constraints
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 48),
            //EighteenPlusIcon Constraints
            eighteenPlusIcon.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc func didTapDismiss(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
}
