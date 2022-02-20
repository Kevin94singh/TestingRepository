//
//  AppDelegate.swift
//  TestingRepository
//
//  Created by Kevin Singh on 17.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var appFlow = AppFlowCoordinator()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        appFlow.start(in: window!) /// safe force unwrap
        return true
    }
}
