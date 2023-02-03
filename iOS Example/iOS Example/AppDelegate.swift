//
//  AppDelegate.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/2.
//

import UIKit

@main public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    public var window: UIWindow?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navi = NavigationController(rootViewController: vc)
        window?.rootViewController = navi
        
        return true
    }
}

