//
//  AppDelegate.swift
//  Gist
//
//  Created by Willian Fagner De Souza Policiano on 27/07/20.
//  Copyright © 2020 Willian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        // Instantiate root view controllers
        let masterViewController = MasterViewController()
        let detailViewController = DetailViewController()

        // Embed in navigation controllers
        let masterNavigationViewController = UINavigationController(rootViewController: masterViewController)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)

        // Embed in Split View controller
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigationViewController,detailNavigationController]
//        splitViewController.preferredPrimaryColumnWidthFraction = 1/3

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        return true
    }


}

