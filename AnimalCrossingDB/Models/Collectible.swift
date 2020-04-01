//
//  Collectible.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import BetterCodable

typealias LosslessStringCodable = LosslessStringConvertible & Codable

@propertyWrapper
struct IntBoolTransform<T: LosslessStringCodable>: Codable {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.wrappedValue = ((try container.decode(Int.self)) == 0 ? false : true) as! T
        } catch {
            self.wrappedValue = false as! T
        }
    }
    
    func encode(to encoder: Encoder) throws {
        let string = String(describing: wrappedValue)
        
        guard let original = Int(string) else {
            let description = "Unable to encode '\(wrappedValue)' back to source type Int"
            throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: description))
        }
        
        try original.encode(to: encoder)
    }
}

protocol Collectible {
    
    associatedtype Area
    
    var name: String? { get set }
    var englishName: String? { get set }
    var price: Int? { get set }
    var area: Area? { get set }
    var availableTime: String? { get set }
    
    var hour0: Bool { get set }
    var hour1: Bool { get set }
    var hour2: Bool { get set }
    var hour3: Bool { get set }
    var hour4: Bool { get set }
    var hour5: Bool { get set }
    var hour6: Bool { get set }
    var hour7: Bool { get set }
    var hour8: Bool { get set }
    var hour9: Bool { get set }
    var hour10: Bool { get set }
    var hour11: Bool { get set }
    var hour12: Bool { get set }
    var hour13: Bool { get set }
    var hour14: Bool { get set }
    var hour15: Bool { get set }
    var hour16: Bool { get set }
    var hour17: Bool { get set }
    var hour18: Bool { get set }
    var hour19: Bool { get set }
    var hour20: Bool { get set }
    var hour21: Bool { get set }
    var hour22: Bool { get set }
    var hour23: Bool { get set }
    
    var month1: Bool { get set }
    var month2: Bool { get set }
    var month3: Bool { get set }
    var month4: Bool { get set }
    var month5: Bool { get set }
    var month6: Bool { get set }
    var month7: Bool { get set }
    var month8: Bool { get set }
    var month9: Bool { get set }
    var month10: Bool { get set }
    var month11: Bool { get set }
    var month12: Bool { get set }
}

extension Collectible {
    
    var hourList: [Bool] {
        [hour0, hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8, hour9, hour10, hour11, hour12, hour13, hour14, hour15, hour16, hour17, hour18, hour19, hour20, hour21, hour22, hour23]
    }
    var monthList: [Bool] {
        [month1, month2, month3, month4, month5, month6, month7, month8, month9, month10, month11, month12]
    }
    
    var isAvailable: Bool {
        hourList[Date().hour] && monthList[Date().month]
    }
}
