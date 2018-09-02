//
//  CryptoCompareApi.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

struct CryptoCompareApi {
  let urlSession: URLSession
  
  init(_ urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  enum DataTransferObjects {
    
  }
  
  enum Endpoints: String {
    case coinList = "https://min-api.cryptocompare.com/data/all/coinlist"
    case priceInfo = "https://min-api.cryptocompare.com/data/price"
    
    func url() -> URL {
      return URL(string: rawValue)!
    }
    
    func request(_ req: CoinPrices.FetchRequest = .initial) -> URLRequest {
      let result = requestImlp(from: req)
      print("GET \(result.url!.absoluteString)")
      return result
    }
    
    private func requestImlp(from req: CoinPrices.FetchRequest) -> URLRequest {
      switch self {
      case .coinList:
        return URLRequest(url: url())
      
      case .priceInfo:
        return buildPriceInfoRequest(from: req)
      }
    }
    
    private func buildPriceInfoRequest(from req: CoinPrices.FetchRequest) -> URLRequest {
      var components = URLComponents(url: url(), resolvingAgainstBaseURL: false)!
      components.queryItems = [
        URLQueryItem(name: "fsym", value: req.symbol),
        URLQueryItem(name: "tsyms", value: req.toSymbol),
        URLQueryItem(name: "e", value: req.exchange.rawValue)
      ]
      
      return URLRequest(url: components.url!)
    }
  }
}
