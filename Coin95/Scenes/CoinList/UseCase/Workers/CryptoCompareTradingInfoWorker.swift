//
//  CryptoCompareTradingInfoWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CryptoCompareAPI
import Promises

struct CryptoCompareTradingInfoWorker {
  typealias TradingInfo = GetSymbolsFullDataRequest.Response.CoinData
  
  private static let maxSymbolsPriceFsymLength = 300
  let api: CryptoCompareAPI
  
  private func buildSymbolsFullDataRequest(
    for coinList: GetCoinListRequest.Response,
    with request: CoinListRequest) -> [GetSymbolsFullDataRequest] {
    
    var currentFsym = ""
    
    return coinList.reduce(into: [String](), {
      let fsym = "\($1.key),\(currentFsym)"
      if fsym.count >= CryptoCompareTradingInfoWorker.maxSymbolsPriceFsymLength {
        $0.append(currentFsym)
        currentFsym = $1.key
      } else {
        currentFsym = fsym
      }
    }).map {
      let exchange = Exchange(rawValue: request.exchange)!
      return GetSymbolsFullDataRequest(fsyms: $0, tsyms: request.toSymbol, e: exchange)
    }
  }
  
  private func fetchTradingInfo(with requests: [GetSymbolsFullDataRequest]) -> Promise<TradingInfo> {
      return all(requests.map(api.send)).then {
      return $0.reduce(into: TradingInfo(), {
        $0.merge($1.raw, uniquingKeysWith: { (current, _) in current })
      })
    }
  }
  
  // TODO: Check why API is not fetching price data for all coins
  func fetchTradingInfo(
    for coinList: GetCoinListRequest.Response,
    with request: CoinListRequest) ->
    Promise<TradingInfo> {
      let requests = buildSymbolsFullDataRequest(for: coinList, with: request)
      return fetchTradingInfo(with: requests).recover { error -> TradingInfo in
        guard let serverError = error as? CryptoCompareError, let _  = serverError.serverErrorMessage else {
          throw error
        }
        
        return TradingInfo()
      }
  }
}
