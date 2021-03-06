//
//  AppDelegate.swift
//  Gist
//
//  Created by Willian Fagner De Souza Policiano on 27/07/20.
//  Copyright © 2020 Willian. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        
        let splitViewController = SplitViewController()

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

