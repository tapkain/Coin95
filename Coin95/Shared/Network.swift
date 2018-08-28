//
//  Network.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import Promises

extension URLSession {
  func dataTask(with request: URLRequest) -> Promise<Data> {
    return Promise { fulfill, reject in
      self.dataTask(with: request) { data, response, error in
        
        do {
          fulfill(try Network.validate(data, response, error))
        } catch let error {
          reject(error)
        }
        
      }.resume()
    }
  }
}

struct Network {
  static func validate(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Data {
    if let _ = error {
      throw AppModels.AppError.requestError
    }
    
    if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
      throw AppModels.AppError.requestError
    }
    
    guard let data = data else {
      throw AppModels.AppError.noData
    }
    
    //print("DATA RECEIVED: \(ByteCountFormatter().string(fromByteCount: Int64(data.count)))")
    
    return data
  }
}


extension Decodable {
  static func decode(from data: Data) throws -> Self {
    do {
      return try JSONDecoder().decode(Self.self, from: data)
    } catch {
      throw AppModels.AppError.badData
    }
  }
}
