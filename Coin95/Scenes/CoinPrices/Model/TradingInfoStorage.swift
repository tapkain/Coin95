//
//  TradingInfoStorage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoCompareAPI

extension TradingInfo: Storage {}


extension WriteTransaction {
  func create(tradingInfo: GetSymbolsFullDataRequest.Response.TradingInfo) -> TradingInfo {
    let primaryKey = TradingInfo.getId(
      currency: tradingInfo.toSymbol,
      exchange: tradingInfo.market,
      symbol: tradingInfo.fromSymbol
    )
    
    let managedTradingInfo: TradingInfo = create(primaryKey: primaryKey)
    
    managedTradingInfo.currency = tradingInfo.toSymbol
    managedTradingInfo.volume = tradingInfo.volumeDayTo?.doubleValue ?? 0.0
    managedTradingInfo.totalVolume = tradingInfo.totalVolume24HourTo?.doubleValue ?? 0.0
    managedTradingInfo.pricePercentChange = tradingInfo.changePctDay.doubleValue!
    managedTradingInfo.marketCap = tradingInfo.marketCap?.doubleValue ?? 0.0
    managedTradingInfo.price = tradingInfo.price.doubleValue!
    managedTradingInfo.exchangeString = tradingInfo.market
    managedTradingInfo.symbol = tradingInfo.fromSymbol
    
    return managedTradingInfo
  }
}
