//
//  StoryCollectionViewCell.swift
//  presentation
//
//  Created by Nihad Ismayilov on 08.08.24.
//

import UIKit
import domain

protocol StoryCollectionViewCellDelegate: NSObject {
    func closeTapped()
    func moveTo(cell: StoryCollectionViewCell, index: Int)
    func openLink(with urlString: String)
}

class StoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    var isImageLoaded: Bool = false
    var navigationLink: String = ""
    weak var delegate: StoryCollectionViewCellDelegate?
    private var isPlaying = true {
        didSet {
            if isPlaying {
                barView.start()
            }else {
                barView.pause()
            }
        }
    }
    
    // MARK: - UI Components
    private lazy var barView: StoryBarView = {
        let view = StoryBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.numberOfStories = 1
        view.emptyColor = .neutral1.withAlphaComponent(0.5)
        view.fullColor = .neutral1
        
        return view
    }()
    private lazy var topStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 16
    )
    private lazy var titleStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 12
    )
    private lazy var titleImageBackView = UIView(backgroundColor: .neutral1)
    private lazy var titleImageView = UIImageView(backgroundColor: .clear)
    private lazy var storyTitleLabel = UILabel(
        text: "Story title",
        textColor: .neutral1,
        textAlignment: .left,
        numberOfLines: 1,
        font: .systemFont(ofSize: 16, weight: .semibold)
    )
    private lazy var closeButton = BaseButton(
        image: UIImage(systemName: "xmark"),
        tintColor: .neutral1
    )
    private lazy var imageView = UIImageView(
        backgroundColor: .clear
    )
    private lazy var linkStackView = UIStackView(
        axis: .vertical,
        alignment: .center,
        distribution: .fill,
        spacing: 6
    )
    private lazy var linkImageView = UIImageView(image: UIImage(systemName: "chevron.up")!, tintColor: .neutral1)
    private lazy var linkButton = BaseButton(
        title: "Keçid et",
        tintColor: .neutral900,
        backgroundColor: .neutral1,
        cornerRadius: 8,
        font: .systemFont(ofSize: 16, weight: .semibold)
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
    
    override func prepareForReuse() {
        isImageLoaded = false
    }
    
    // MARK: - Functions
    private func setup() {
        isImageLoaded = false
        contentView.addSubviews(barView, topStackView, imageView, linkStackView)
        topStackView.addArrangedSubviews(titleStackView, closeButton)
        titleStackView.addArrangedSubviews(titleImageBackView, storyTitleLabel)
        linkStackView.addArrangedSubviews(linkImageView, linkButton)
        titleImageBackView.addSubview(titleImageView)
        contentView.sendSubviewToBack(imageView)
        titleImageBackView.cornerRadius = 24
        titleImageView.cornerRadius = 22
        titleImageView.clipsToBounds = true
        linkButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        NSLayoutConstraint.activate([
            barView.heightAnchor.constraint(equalToConstant: 3),
            barView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor/*, constant: 12*/),
            barView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor/*, constant: -12*/),
            
            topStackView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 16),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            titleImageBackView.widthAnchor.constraint(equalToConstant: 48),
            titleImageBackView.heightAnchor.constraint(equalToConstant: 48),
            
            titleImageView.topAnchor.constraint(equalTo: titleImageBackView.topAnchor, constant: 2),
            titleImageView.leadingAnchor.constraint(equalTo: titleImageBackView.leadingAnchor, constant: 2),
            titleImageView.trailingAnchor.constraint(equalTo: titleImageBackView.trailingAnchor, constant: -2),
            titleImageView.bottomAnchor.constraint(equalTo: titleImageBackView.bottomAnchor, constant: -2),
            
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            linkStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            linkStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -64),
            linkImageView.widthAnchor.constraint(equalToConstant: 24),
            linkImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        closeButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        setupGestures()
    }
    
    func setupCellWith(data: StoryData?) {
        if let url = URL(string: data?.fileURL ?? "") {
            titleImageView.loadImage(with: url)
            imageView.loadImage(with: url)
            isImageLoaded = true
        }
        storyTitleLabel.text = data?.title
        navigationLink = data?.redirectURL ?? ""
        if isImageLoaded, !barView.isAnimating {
            barView.reset()
        }
    }
    
    @objc func didTap(_ sender: UIButton) {
        switch sender {
        case linkButton:
            barView.stop()
            delegate?.openLink(with: navigationLink)
        case closeButton:
            barView.resetAndStop()
            delegate?.closeTapped()
        default: break
        }
    }
    
    func stopAndRemove() {
        if barView.isDescendant(of: self) {
            barView.resetAndStop()
        }
    }
    
    func resetOrSetPlayer() {
        barView.reset()
    }
    
//    func resetOrSetPlayer() {
//        switch type {
//        case .jpg, .png:
//            storyBar.reset()
//        case .mp4:
//            setVideoPlayer()
//        default:
//            break
//        }
//    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongClick(_:)))
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(sender:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(sender:)))
        swipeUpGesture.direction = .up
        swipeDownGesture.direction = .down
        
        contentView.addGestureRecognizer(tapGesture)
        contentView.addGestureRecognizer(longGesture)
        contentView.addGestureRecognizer(swipeUpGesture)
        contentView.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let centerX = self.bounds.midX
        
        if sender.state == .ended {
            if location.x < centerX {
                delegate?.moveTo(cell: self, index: -1)
            } else {
                delegate?.moveTo(cell: self, index: 1)
            }
        }
    }
    
    @objc private func handleLongClick(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isPlaying = false
        case .ended:
            isPlaying = true
        default:
            break
        }
    }
    
    @objc func handleSwipeDown(sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            barView.stop()
            delegate?.closeTapped()
        } else if sender.direction == .up {
            delegate?.openLink(with: navigationLink)
        }
    }
}

extension StoryCollectionViewCell: StoryBarViewDelegate {
    func doneAction() {
        delegate?.moveTo(cell: self, index: 1)
    }
}
