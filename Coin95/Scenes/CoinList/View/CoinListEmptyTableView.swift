//
//  CoinListEmptyTableView.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/19/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import UIKit
import Lottie

class CoinListEmptyTableView: UIView {
  private lazy var animationView: LOTAnimationView = {
    let animationView = LOTAnimationView(name: "emptyBox")
    animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin]
    animationView.contentMode = .scaleAspectFit
    
    return animationView
  }()
  
  private lazy var infoLabel: UILabel = {
    let infoLabel = UILabel(text: "No Data :(")
    infoLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
    infoLabel.textColor = .white
    return infoLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .black
    addSubview(animationView)
    addSubview(infoLabel)
  }
  
  func show() {
    isHidden = false
    animationView.play()
  }
}
