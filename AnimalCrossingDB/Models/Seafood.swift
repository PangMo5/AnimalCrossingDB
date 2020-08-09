//
//  Seafood.swift
//  AnimalCrossingDB
//
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteSeafoodIDs: DefaultsKey<[Int]> { return .init("favoriteSeafoodIDs", defaultValue: []) }
    var gatheredSeafoodIDs: DefaultsKey<[Int]> { return .init("gatheredSeafoodIDs", defaultValue: []) }
    var endowmentedSeafoodIDs: DefaultsKey<[Int]> { return .init("endowmentedSeafoodIDs", defaultValue: []) }
}

struct Seafood: Collectible, Codable {
    
    enum Area: String, Codable {
        case never
    }
    
    enum Size: Int, Codable, CaseIterable {
        case xSmall = 1
        case small = 2
        case medium = 3
        case large = 4
        case xLarge = 5
        
        var localized: String {
            switch self {
            case .xSmall:
                return "엄청 작음"
            case .small:
                return "작음"
            case .medium:
                return "보통"
            case .large:
                return "큼"
            case .xLarge:
                return "엄청 큼"
            }
        }
    }
    
    enum Speed: Int, Codable, CaseIterable {
        case `static` = 0
        case verySlow = 1
        case slow = 2
        case normal = 3
        case fast = 4
        case veryFast = 5
        
        var localized: String {
            switch self {
            case .static:
                return "고정"
            case .verySlow:
                return "엄청 느림"
            case .slow:
                return "느림"
            case .normal:
                return "보통"
            case .fast:
                return "빠름"
            case .veryFast:
                return "엄청 빠름"
            }
        }
    }
    
    
    var id: String {
        "\(realID ?? 0)_seafood"
    }
    var realID: Int?
    var name: String?
    var englishName: String?
    var price: Int?
    var area: Area?
    var size: Size?
    var availableTime: String?
    var allDayMonths: [Int]? = []
    
    @IntBoolTransform
    var time1: Bool
    @IntBoolTransform
    var time2: Bool
    @IntBoolTransform
    var time3: Bool
    @IntBoolTransform
    var time4: Bool
    
    var hour0: Bool { time4 }
    var hour1: Bool { time4 }
    var hour2: Bool { time4 }
    var hour3: Bool { time4 }
    var hour4: Bool { time1 }
    var hour5: Bool { time1 }
    var hour6: Bool { time1 }
    var hour7: Bool { time1 }
    var hour8: Bool { time1 }
    var hour9: Bool { time2 }
    var hour10: Bool { time2 }
    var hour11: Bool { time2 }
    var hour12: Bool { time2 }
    var hour13: Bool { time2 }
    var hour14: Bool { time2 }
    var hour15: Bool { time2 }
    var hour16: Bool { time3 }
    var hour17: Bool { time3 }
    var hour18: Bool { time3 }
    var hour19: Bool { time3 }
    var hour20: Bool { time3 }
    var hour21: Bool { time4 }
    var hour22: Bool { time4 }
    var hour23: Bool { time4 }
    
    @IntBoolTransform
    var month1: Bool
    @IntBoolTransform
    var month2: Bool
    @IntBoolTransform
    var month3: Bool
    @IntBoolTransform
    var month4: Bool
    @IntBoolTransform
    var month5: Bool
    @IntBoolTransform
    var month6: Bool
    @IntBoolTransform
    var month7: Bool
    @IntBoolTransform
    var month8: Bool
    @IntBoolTransform
    var month9: Bool
    @IntBoolTransform
    var month10: Bool
    @IntBoolTransform
    var month11: Bool
    @IntBoolTransform
    var month12: Bool
    
    @SwiftyUserDefault(keyPath: \.favoriteSeafoodIDs)
    fileprivate var favoriteSeafoodIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredSeafoodIDs)
    fileprivate var gatheredSeafoodIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedSeafoodIDs)
    fileprivate var endowmentedSeafoodIDsDefault: [Int]
}

extension Seafood {
    
    enum CodingKeys: String, CodingKey {
        case realID = "id"
        case name
        case englishName
        case price
        case area
        case size
        case availableTime = "timeString"
        case month1
        case month2
        case month3
        case month4
        case month5
        case month6
        case month7
        case month8
        case month9
        case month10
        case month11
        case month12
        case time1
        case time2
        case time3
        case time4
    }
}

extension Seafood: Equatable {
    
    static func == (lhs: Seafood, rhs: Seafood) -> Bool {
        lhs.id == rhs.id
    }
}

extension Seafood: Comparable {
    static func < (lhs: Seafood, rhs: Seafood) -> Bool {
        (lhs.realID ?? 0) < (rhs.realID ?? 0)
    }
    
    
    static func > (lhs: Seafood, rhs: Seafood) -> Bool {
        (lhs.realID ?? 0) > (rhs.realID ?? 0)
    }
}

extension Seafood {
    
    var image: UIImage {
        StorageManager.shared.seafoodImageList[realID ?? 0] ?? UIImage(systemName: "tortoise.fill")!
    }
    
    var isFavorite: Bool {
        guard let id = realID else { return false }
        return favoriteSeafoodIDsDefault.contains(id)
    }
    
    var isGathered: Bool {
        guard let id = realID else { return false }
        return gatheredSeafoodIDsDefault.contains(id)
    }
    
    var isEndowmented: Bool {
        guard let id = realID else { return false }
        return endowmentedSeafoodIDsDefault.contains(id)
    }
}

extension Seafood {
    
    static var sampleSeafood: Seafood = .init(realID: 1, name: "이름", englishName: "english name", price: 10000, area: nil, size: .small, availableTime: "시간", allDayMonths: [], time1: true, time2: true, time3: true, time4: true, month1: true, month2: true, month3: true, month4: true, month5: true, month6: true, month7: true, month8: true, month9: true, month10: true, month11: true, month12: true)
}

extension Seafood {
    
    func switchFavorite() {
        guard let id = realID else { return }
        if isFavorite {
            favoriteSeafoodIDsDefault.removeAll(id)
        } else {
            favoriteSeafoodIDsDefault.append(id)
        }
    }
    
    func switchGathering() {
        guard let id = realID else { return }
        if isGathered {
            gatheredSeafoodIDsDefault.removeAll(id)
            if isEndowmented {
                switchEndowment()
            }
        } else {
            gatheredSeafoodIDsDefault.append(id)
        }
    }
    
    func switchEndowment() {
        guard let id = realID else { return }
        if isEndowmented {
            endowmentedSeafoodIDsDefault.removeAll(id)
        } else {
            endowmentedSeafoodIDsDefault.append(id)
            if !isGathered {
                switchGathering()
            }
        }
    }
}
