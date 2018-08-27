//
//  Point.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

extension CGPoint {
  init(from point: Point) {
    self.init(x: point.x, y: point.y)
  }
  
  func asPoint() -> Point {
    return Point.make(x: Double(x), y: Double(y))
  }
}

class Point: Object {
  @objc dynamic var x = 0.0
  @objc dynamic var y = 0.0
  
  static func make(x: Double, y: Double) -> Point {
    let point = Point()
    point.x = x
    point.y = y
    return point
  }
}
