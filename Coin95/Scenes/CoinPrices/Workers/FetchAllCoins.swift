//
//  FetchAllCoins.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/27/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension CryptoCompareApi {
  private func fetchAllCoins() -> Promise<DataTransferObjects.CoinList> {
    return urlSession.dataTask(with: Endpoints.coinList.request()).then {
      try DataTransferObjects.CoinList.decode(from: $0)
    }
  }
  
  func fetchAllCoins() -> Promise<[Coin]> {
    return fetchAllCoins().then(transform)
  }
  
  private func transform(coinList list: DataTransferObjects.CoinList) -> [Coin] {
    return list.data.values.map { coinInfo -> Coin in
      let coinPrice = Coin()
      coinPrice.merge(with: coinInfo, baseUrl: list.baseImageUrl)
      return coinPrice
    }
  }
}


extension CryptoCompareApi.DataTransferObjects {
  
  struct CoinList: Decodable {
    enum CodingKeys: String, CodingKey {
      case response = "Response"
      case message = "Message"
      case baseImageUrl = "BaseImageUrl"
      case baseLinkUrl = "BaseLinkUrl"
      case data = "Data"
      case type = "Type"
    }
    
    let response: String
    let message: String
    let baseImageUrl: String
    let baseLinkUrl: String
    let data: [String: CoinInfo]
    
    struct CoinInfo: Decodable {
      enum CodingKeys: String, CodingKey {
        case id = "Id"
        case url = "Url"
        case imageUrl = "ImageUrl"
        case name = "Name"
        case coinName = "CoinName"
        case fullName = "FullName"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case sortOrder = "SortOrder"
      }
      
      let id: String
      let url: String
      let imageUrl: String?
      let name: String
      let coinName: String
      let fullName: String
      let algorithm: String
      let proofType: String
      let sortOrder: String
    }
    
    let type: Int?
  }
}


extension Coin {
  func merge(with coinInfo: CryptoCompareApi.DataTransferObjects.CoinList.CoinInfo, baseUrl: String) {
    name = coinInfo.coinName
    symbol = coinInfo.name
    
    if let url = coinInfo.imageUrl {
      imageUrl = baseUrl + url
    }
  }
}
