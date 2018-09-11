//
//  HistoryEntry.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

final class CoinHistoryEntry: Object {
  @objc dynamic var time = 0
  @objc dynamic var close = 0.0
  @objc dynamic var high = 0.0
  @objc dynamic var low = 0.0
  @objc dynamic var open = 0.0
  @objc dynamic var volumeFrom = 0.0
  @objc dynamic var volumeTo = 0.0
  @objc dynamic var currency = ""
}
