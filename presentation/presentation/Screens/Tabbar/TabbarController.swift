//
//  TabbarController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import UIKit

public class TabbarController: UITabBarController {
    private var backViews: [UIView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabbarItems()
    }
    
    private func setupView() {
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
    
    private func setupTabbarItems() {
        let homeNav = UINavigationController(
            rootViewController: Router.getRegisterVC()
        )
        let liveNav = UINavigationController(
            rootViewController: Router.getTestVC()
        )
        let sportNav = UINavigationController(
            rootViewController: Router.getTestVC()
        )
        let couponNav = UINavigationController(
            rootViewController: Router.getTestVC()
        )
        let menuNav = UINavigationController(
            rootViewController: Router.getTestVC()
        )
        
        homeNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: .icHome,
                                          selectedImage: .icHome)
        
        liveNav.tabBarItem = UITabBarItem(title: "Live",
                                          image: .icLive,
                                          selectedImage: .icLive)
        
        sportNav.tabBarItem = UITabBarItem(title: "Sports",
                                           image: .icSport,
                                           selectedImage: .icSport)
        
        couponNav.tabBarItem = UITabBarItem(title: "Coupons",
                                            image: .icCoupon,
                                            selectedImage: .icCoupon)
        
        menuNav.tabBarItem = UITabBarItem(title: "Menu",
                                          image: .icMenu,
                                          selectedImage: .icMenu)
        
        setViewControllers(
            [homeNav, liveNav, sportNav, couponNav, menuNav],
            animated: false
        )
        
//        setupLabelBackViews()
    }
    
    private func setupLabelBackViews() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            if let itemView = item.value(forKey: "view") as? UIView {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(view)
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: itemView.topAnchor),
                    view.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
                    view.bottomAnchor.constraint(equalTo: itemView.bottomAnchor)
                ])
                backViews.append(view)
            }
        }
    }
}
