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
  let filterSymbolsWorker: FilterSymbolsWorker
  
  init(api: CryptoCompareAPI) {
    self.api = api
    self.filterSymbolsWorker = FilterSymbolsWorker(api: api)
  }
  
  private func makeSymbolsFullDataRequest(
    for coinList: GetCoinListRequest.Response,
    with request: CoinListRequest) -> [GetSymbolsFullDataRequest] {
    
    let totalFsymLength = coinList.reduce(0, { $0 + $1.key.count }) + coinList.count
    let exchange = Exchange(rawValue: request.exchange)!
    
    if totalFsymLength < CryptoCompareTradingInfoWorker.maxSymbolsPriceFsymLength {
      let fsyms = coinList.reduce("", { "\($0),\($1.key)" })
      return [GetSymbolsFullDataRequest(fsyms: fsyms, tsyms: request.toSymbol, e: exchange)]
    } else {
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
        GetSymbolsFullDataRequest(fsyms: $0, tsyms: request.toSymbol, e: exchange)
      }
    }
  }
  
  // TODO: Check why API is not fetching price data for all coins
  //
  func fetchTradingInfo(
    for coinList: GetCoinListRequest.Response,
    with request: CoinListRequest
  ) -> Promise<TradingInfo> {
    return filterSymbolsWorker.filterSupportedSymbols(for: coinList, request).then {
      let requests = self.makeSymbolsFullDataRequest(for: $0, with: request)
      
      return all(requests.map(self.api.send)).then {
        return $0.reduce(into: TradingInfo(), {
          $0.merge($1.raw, uniquingKeysWith: { (current, _) in current })
        })
      }.catch {
        print($0.localizedDescription)
      }
    }
  }
}
