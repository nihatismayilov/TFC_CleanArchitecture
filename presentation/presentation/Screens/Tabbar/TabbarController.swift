//
//  TabbarController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import UIKit

public class TabbarController: UITabBarController {
    var tabbarViews : [TabbarView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        generateControllers()
    }
    
    private func setupTabbar() {
        UITabBar.appearance().barTintColor = .neutral800
        view.backgroundColor = .neutral800
        
        tabBar.barStyle = .default
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
    }
    
    private func setupView() {
        for x in 0..<tabbarViews.count {
            view.addSubview(tabbarViews[x])
            tabbarViews[x].translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tabbarViews[x].centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
                tabbarViews[x].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/CGFloat(tabbarViews.count)),
                tabbarViews[x].heightAnchor.constraint(equalTo: tabBar.heightAnchor),
            ])
            if x == 0 {
                tabbarViews[x].leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
            } else {
                tabbarViews[x].leftAnchor.constraint(equalTo: tabbarViews[x-1].rightAnchor).isActive = true
            }
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            tabbarViews[x].addGestureRecognizer(gesture)
        }
    }
    
    private func generateControllers(){
        let home = generateViewControllers(image: .icHome, title: "Ana səhifə", isSelected: true, vc: Router.getForceUpdateVC())
        let live = generateViewControllers(image: .icLive, title: "Canlı", isSelected: false, vc: Router.getPersonalInformationVC())
        let sport = generateViewControllers(image: .icSport, title: "İdman", isSelected: false, vc: Router.getRegisterVC())
        let coupon = generateViewControllers(image: .icCoupon, title: "Kuponlarım", isSelected: false, vc: Router.getRegisterVC())
        let menu = generateViewControllers(image: .icMenu, title: "Menyu", isSelected: false, vc: Router.getRegisterVC())
        viewControllers = [home, live, sport, coupon, menu]
        
        setupView()
    }
    
    private func generateViewControllers(image: UIImage, title: String, isSelected: Bool, vc: UIViewController) -> UIViewController {
        let tabbarView = TabbarView(image: image, title: title, isSelected: isSelected)
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        tabbarView.isSelected = isSelected
        tabbarViews.append(tabbarView)
        return vc
    }
    
    @objc private func viewTapped(sender: UITapGestureRecognizer) {
        tabbarViews.enumerated().forEach { index, view in
            tabbarViews[index].isSelected = false
            if view == sender.view {
                selectedIndex = index
                tabbarViews[index].isSelected = true
            }
        }
    }
}

class TabbarView: UIView {
    // MARK: - Variables
    var isSelected: Bool = false {
        didSet {
            updateSelectionUI(isSelected)
        }
    }
    var image: UIImage? {
        get {
            imageView.image
        } set {
            imageView.image = newValue
        }
    }
    var title: String? {
        get {
            titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .neutral300
        
        return imageView
    }()
    
    private lazy var titleView = UIView(backgroundColor: .clear, cornerRadius: 8)
    
    private lazy var titleLabel = UILabel(
        textColor: .neutral900,
        textAlignment: .center,
        numberOfLines: 1,
        font: .systemFont(ofSize: 10, weight: .medium)
    )
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    init(image: UIImage, title: String, isSelected: Bool) {
        super.init(frame: .zero)
        setup()
        self.image = image
        self.title = title
        self.isSelected = isSelected
    }
    
    // MARK: - Functions
    private func setup() {
        addSubviews(imageView, titleView)
        titleView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleView.heightAnchor.constraint(equalToConstant: 16),
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
        ])
    }
    
    private func updateSelectionUI(_ isSelected: Bool) {
        if isSelected == true {
            titleView.backgroundColor = .white
            titleLabel.textColor = .neutral900
            imageView.tintColor = .neutral1
        } else {
            titleView.backgroundColor = .clear
            titleLabel.textColor = .neutral300
            imageView.tintColor = .neutral300
        }
    }
}
