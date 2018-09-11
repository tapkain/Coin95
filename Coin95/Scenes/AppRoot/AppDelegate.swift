//
//  AppDelegate.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 7/18/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import Promises

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let appCoordinator = AppCoordinator()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    DispatchQueue.promises = DispatchQueue.global()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = appCoordinator.rootViewController
    appCoordinator.start()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // TODO: Implement background fetch
  }
}

