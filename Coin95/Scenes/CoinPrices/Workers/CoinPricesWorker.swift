//
//  CoinPricesWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/28/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises
import CryptoCompareAPI

extension CoinPrices {
  struct Worker: CoinPricesWorker {
    private static let maxSymbolsPriceFsymLength = 300
    private let api = CryptoCompareAPI()
    
    func fetchCoins(with request: CoinPrices.FetchRequest) -> Promise<Void> {
      return api.send(GetCoinListRequest()).then { coinList in
        self.fetchCoinPrices(for: coinList, with: request).then { data in
          try Coin.write { transaction in
            coinList.forEach {
              transaction.create(coinListItem: $0.value, tradingInfo: data[$0.key])
            }
          }
        }
      }
    }
    
    private func buildSymbolsFullDataRequest(for coinList: GetCoinListRequest.Response, with request: CoinPrices.FetchRequest) -> [GetSymbolsFullDataRequest] {
      var currentFsym = ""
      
      return coinList.reduce(into: [String](), {
        let fsym = "\($1.key),\(currentFsym)"
        if fsym.count >= Worker.maxSymbolsPriceFsymLength {
          $0.append(currentFsym)
          currentFsym = $1.key
        } else {
          currentFsym = fsym
        }
      }).map {
        GetSymbolsFullDataRequest(fsyms: $0, tsyms: request.toSymbol, e: request.exchange)
      }
    }
    
    // TODO: Check why API is not fetching price data for all coins
    private func fetchCoinPrices(for coinList: GetCoinListRequest.Response, with request: CoinPrices.FetchRequest) -> Promise<GetSymbolsFullDataRequest.Response.CoinData> {
      let requests = buildSymbolsFullDataRequest(for: coinList, with: request)
      return all(requests.map(api.send)).then {
        return $0.reduce(into: GetSymbolsFullDataRequest.Response.CoinData(), {
          $0.merge($1.raw, uniquingKeysWith: { (current, _) in current })
        })
      }
    }
  }
}
