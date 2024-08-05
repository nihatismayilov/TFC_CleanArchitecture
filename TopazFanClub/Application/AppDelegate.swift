//
//  AppDelegate.swift
//  TopazFanClub
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import UIKit
import presentation
import domain
import data

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PresentationDIConfigurator.configure(container: DIContainer.shared)
        DomainDIConfigurator.configure(container: DIContainer.shared)
        DataDIConfigurator.configure(container: DIContainer.shared)
        
//        let startVC = DIContainer.shared.resolve(TabbarController.self)!
//        let startVC = DIContainer.shared.resolve(RegisterViewController.self)!
        let startVC = DIContainer.shared.resolve(OtpViewController.self)!
        setupInitialPage(startVC)
        
        return true
    }
    
    private func setupInitialPage(_ vc: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
}

