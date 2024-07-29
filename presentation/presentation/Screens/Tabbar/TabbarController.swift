//
//  TabbarController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import UIKit

//public class TabbarController: UITabBarController {
//    private var backViews: [UIView] = []
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        setupTabbarItems()
//    }
//    
//    private func setupView() {
//        UITabBar.appearance().barTintColor = .neutral800
//        view.backgroundColor = .neutral800
//        
//        tabBar.barStyle = .default
//        tabBar.tintColor = .white
//        tabBar.unselectedItemTintColor = .lightGray
//        tabBar.isTranslucent = false
//        
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tabBar.layer.shadowRadius = 5
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBar.layer.shadowOpacity = 0.1
//    }
//    
//    private func setupTabbarItems() {
//        let homeNav = UINavigationController(
//            rootViewController: Router.getPersonalInformationVC()
//        )
//        let liveNav = UINavigationController(
//            rootViewController: Router.getForceUpdateVC()
//        )
//        let sportNav = UINavigationController(
//            rootViewController: Router.getForceUpdateVC()
//        )
//        let couponNav = UINavigationController(
//            rootViewController: Router.getForceUpdateVC()
//        )
//        let menuNav = UINavigationController(
//            rootViewController: Router.getForceUpdateVC()
//        )
//        
//        homeNav.tabBarItem = UITabBarItem(title: "Home",
//                                          image: .icHome,
//                                          selectedImage: .icHome)
//        
//        liveNav.tabBarItem = UITabBarItem(title: "Live",
//                                          image: .icLive,
//                                          selectedImage: .icLive)
//        
//        sportNav.tabBarItem = UITabBarItem(title: "Sports",
//                                           image: .icSport,
//                                           selectedImage: .icSport)
//        
//        couponNav.tabBarItem = UITabBarItem(title: "Coupons",
//                                            image: .icCoupon,
//                                            selectedImage: .icCoupon)
//        
//        menuNav.tabBarItem = UITabBarItem(title: "Menu",
//                                          image: .icMenu,
//                                          selectedImage: .icMenu)
//        
//        setViewControllers(
//            [homeNav, liveNav, sportNav, couponNav, menuNav],
//            animated: false
//        )
//    }
//}

public class TabbarController: UITabBarController {
    let tabbarItemBackgroundView = UIView()
    var centerConstraint: NSLayoutConstraint?
    var buttons : [UIButton] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        generateControllers()
    }
    
    private func setupView() {
        view.addSubview(tabbarItemBackgroundView)
        tabbarItemBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        for x in 0..<buttons.count {
            view.addSubview(buttons[x])
            buttons[x].translatesAutoresizingMaskIntoConstraints = false
            buttons[x].tag = x
            
            NSLayoutConstraint.activate([
                buttons[x].centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
                buttons[x].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/CGFloat(buttons.count)),
                buttons[x].heightAnchor.constraint(equalTo: tabBar.heightAnchor),
            ])
            if x == 0 {
                buttons[x].leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            } else {
                buttons[x].leftAnchor.constraint(equalTo: buttons[x-1].rightAnchor).isActive = true
            }
            buttons[x].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        centerConstraint = tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: buttons[0].centerXAnchor)
        centerConstraint?.isActive = true
        
        
        tabbarItemBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/CGFloat(buttons.count), constant: -10).isActive = true
        tabbarItemBackgroundView.heightAnchor.constraint(equalTo: tabBar.heightAnchor, constant: -10).isActive = true
        tabbarItemBackgroundView.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
        tabbarItemBackgroundView.layer.cornerRadius = 25
        tabbarItemBackgroundView.backgroundColor = .orange
    }
    
    private func generateControllers(){
        let home = generateViewControllers(image: UIImage(systemName: "house.fill")!, vc: Router.getPersonalInformationVC())
        let profile = generateViewControllers(image: UIImage(systemName: "person.fill")!, vc: Router.getPersonalInformationVC())
        let setting = generateViewControllers(image: UIImage(systemName: "gearshape.fill")!, vc: Router.getPersonalInformationVC())
        let bookmark = generateViewControllers(image: UIImage(systemName: "bookmark.fill")!, vc: Router.getPersonalInformationVC())
        let bookmark2 = generateViewControllers(image: UIImage(systemName: "heart.fill")!, vc: Router.getPersonalInformationVC())
        viewControllers = [home, profile, setting, bookmark, bookmark2]
        
        setupView()
    }
    
    private func generateViewControllers(image: UIImage, vc: UIViewController) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .orange
        let image = image
        button.setImage(image, for: .normal)
        buttons.append(button)
        return vc
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        selectedIndex = sender.tag
        
        for button in buttons {
            button.tintColor = .orange
        }
        
        self.centerConstraint?.isActive = false
        self.centerConstraint = self.tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: self.buttons[sender.tag].centerXAnchor)
        self.centerConstraint?.isActive = true
        self.buttons[sender.tag].tintColor = .black
        self.view.layoutIfNeeded()
    }
}

//class TabbarView: UIView {
//    var image: UIImage? {
//        get {
//            imageView.image
//        } set {
//            imageView.image = newValue
//        }
//    }
//    private lazy var stackView = UIStackView(
//        axis: .vertical,
//        alignment: .fill,
//        distribution: .equalSpacing,
//        spacing: 4
//    )
//    
//    private lazy var imageView: UIImageView = {
//        let imageView = UIImageView()
//        
//        return imageView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//}
