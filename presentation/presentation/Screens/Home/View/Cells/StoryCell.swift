//
//  StoryCell.swift
//  presentation
//
//  Created by Nihad Ismayilov on 08.08.24.
//

import UIKit

class StoryCell: UICollectionViewCell {
    // MARK: - Variables
    
    // MARK: - UI Components
    private lazy var indicatorView = UIView(backgroundColor: .clear)
    private lazy var imageView = UIImageView(
        backgroundColor: .clear
    )
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        contentView.addSubviews(indicatorView)
        indicatorView.addSubview(imageView)
        indicatorView.borderWidth = 2
        indicatorView.borderColor = .red600
        indicatorView.cornerRadius = 17
        imageView.cornerRadius = 16
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.topAnchor.constraint(equalTo: indicatorView.topAnchor, constant: 2),
            imageView.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: -2),
        ])
    }
    
    func setupCellWith(imageString: String?, isRead: Bool?) {
        if let url = URL(string: imageString ?? "") {
            imageView.loadImage(with: url)
        }
        indicatorView.borderColor = isRead == true ? .secondaryBorder : .red600
    }
}
