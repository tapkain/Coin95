//
//  HistoryEntryStorage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoCompareAPI

extension CoinHistoryEntry: Repository {}


extension WriteTransaction {
  func create(historyEntry: HistoryEntry, symbol: String) -> CoinHistoryEntry {
    let entry = CoinHistoryEntry()
    
    entry.close = historyEntry.close
    entry.currency = symbol
    entry.high = historyEntry.high
    entry.low = historyEntry.low
    entry.open = historyEntry.open
    entry.time = historyEntry.time
    entry.volumeFrom = historyEntry.volumeFrom
    entry.volumeTo = historyEntry.volumeTo
    
    return entry
  }
}
