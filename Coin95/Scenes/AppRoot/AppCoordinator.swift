//
//  AppCoordinator.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
  
  let rootViewController = UITabBarController()
  let coinPricesCoordinator = CoinPricesCoordinator()
  let settingsCoordinator = SettingsCoordinator()
  
  var coinPrices: UIViewController {
    coinPricesCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    return coinPricesCoordinator.rootViewController
  }
  
  var settings: UIViewController {
    settingsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
    
    return settingsCoordinator.rootViewController
  }
  
  func start() {
    coinPricesCoordinator.start()
    settingsCoordinator.start()
    rootViewController.viewControllers = [coinPrices, settings]
  }
}
