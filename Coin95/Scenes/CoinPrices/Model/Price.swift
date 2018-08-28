//
//  Price.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/28/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

class Price: Object {
  @objc dynamic var currency = ""
  @objc dynamic var value = 0.0
}
