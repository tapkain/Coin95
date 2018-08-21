//
//  CoinMarketCapDataTransferObjects.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum CoinMarketCap {
  struct Tickers: Decodable {
    let data: [String: Ticker]
    let metadata: Metadata
    
    struct Ticker: Decodable {
      enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case websiteSlug = "website_slug"
        case rank
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case quotes
        case lastUpdated = "last_updated"
      }
      
      let id: Int
      let name: String
      let symbol: String
      let websiteSlug: String
      let rank: Int
      let circulatingSupply: Double
      let totalSupply: Double
      let maxSupply: Double?
      let quotes: [String: Quote]

      struct Quote: Decodable {
        enum CodingKeys: String, CodingKey {
          case price
          case volume24h = "volume_24h"
          case marketCap = "market_cap"
          case percentChange1h = "percent_change_1h"
          case percentChange24h = "percent_change_24h"
          case percentChange7d = "percent_change_7d"
        }
        
        let price: Double
        let volume24h: Double
        let marketCap: Double
        let percentChange1h: Double
        let percentChange24h: Double
        let percentChange7d: Double
      }
      
      let lastUpdated: Int
    }
  }
  
  struct Metadata: Decodable {
    enum CodingKeys: String, CodingKey {
      case timestamp, cryptocurrenciesCount = "num_cryptocurrencies", error
    }
    
    let timestamp: Int
    let cryptocurrenciesCount: Int
    let error: String?
  }
}


extension CoinPrice {
  init(from ticker: CoinMarketCap.Tickers.Ticker) {
    self.init()
    
    name = ticker.name
    symbol = ticker.symbol
    
    let quote = ticker.quotes.first!.value
    price = quote.price
    priceChange = quote.percentChange24h
  }
}
