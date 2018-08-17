//
//  Coin.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/12/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

class Coin: Object {
  @objc dynamic var name = ""
  @objc dynamic var ticker = ""
  @objc dynamic var price = ""
}
