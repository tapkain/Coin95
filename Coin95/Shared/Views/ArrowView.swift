//
//  ArrowView.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/24/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import UIKit

class ArrowView: UIView {
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: rect.width / 2, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
    path.addLine(to: CGPoint(x: 0, y: rect.height))
    path.close()
    tintColor.setFill()
    path.fill()
  }
}
