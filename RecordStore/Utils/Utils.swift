//
//  Utils.swift
//  RecordStore
//
//  Created by Champion on 10/26/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import Foundation

struct Utils {

    static func splitPrice(price: Double) -> [String]{
        var stringArray = [String]()
        let myPrice = String(price)
        var splitedPrice = myPrice.split(separator: ".")
        let subPrices = String(splitedPrice[1])
        var subPrice = String(subPrices.first!)
        let newSubPrices = subPrices.dropFirst()
        subPrice = subPrice + String(newSubPrices.first ?? "9")
        stringArray.append("$"+splitedPrice[0])
        stringArray.append(subPrice)
        return stringArray
    }
}
