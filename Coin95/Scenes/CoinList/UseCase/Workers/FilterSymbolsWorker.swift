//
//  FilterSymbolsWorker.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/14/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import CryptoCompareAPI
import Promises

struct FilterSymbolsWorker {
  let api: CryptoCompareAPI
  
  func filterSupportedSymbols(for coinList: CoinListResponse, _ request: CoinListRequest) -> Promise<CoinListResponse> {
    if Exchange(rawValue: request.exchange)! == .defaultMarket {
      return Promise(coinList)
    }
    
    return api.send(GetExchangesRequest()).then {
      return self.filterSupportedSymbols(for: coinList, request, $0)
    }
  }
  
  private func filterSupportedSymbols(
    for coinList: CoinListResponse,
    _ request: CoinListRequest,
    _ exchanges: GetExchangesRequest.Response
  ) -> Promise<CoinListResponse> {
    return Promise(
      coinList.filter {
        guard let exchange = exchanges[request.exchange] else { return false }
        guard let coin = exchange[$0.key] else { return false }
        return coin.contains(request.currency)
      }
    )
  }
}
