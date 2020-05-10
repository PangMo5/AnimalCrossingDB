//
//  Fossil.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/05/10.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteFossilIDs: DefaultsKey<[Int]> { return .init("favoriteFossilIDs", defaultValue: []) }
    var gatheredFossilIDs: DefaultsKey<[Int]> { return .init("gatheredFossilIDs", defaultValue: []) }
    var endowmentedFossilIDs: DefaultsKey<[Int]> { return .init("endowmentedFossilIDs", defaultValue: []) }
}

struct Fossil: Gatherable, Codable, Identifiable {
    
    enum Size: String, Codable {
        case oneOne = "1x1"
        case twoTwo = "2x2"
    }
    
    enum TypeEnum: String, Codable {
        case single
        case set
    }
    
    var id: String {
        "\(realID ?? 0)_art"
    }
    var realID: Int?
    var setID: Int?
    var name: String?
    var enName: String?
    var size: Size?
    var type: TypeEnum?
    var setName: String?
    var enSetName: String?
    var price: String?
    
    @SwiftyUserDefault(keyPath: \.favoriteFossilIDs)
    fileprivate var favoriteArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredFossilIDs)
    fileprivate var gatheredArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedFossilIDs)
    fileprivate var endowmentedArtIDsDefault: [Int]
}

extension Fossil {
    
    enum CodingKeys: String, CodingKey {
        case realID = "id"
        case setID
        case name
        case enName
        case size
        case type
        case setName
        case enSetName
        case price
    }
}

extension Fossil {
    
    var isFavorite: Bool {
        guard let id = realID else { return false }
        return favoriteArtIDsDefault.contains(id)
    }
    
    var isGathered: Bool {
        guard let id = realID else { return false }
        return gatheredArtIDsDefault.contains(id)
    }
    
    var isEndowmented: Bool {
        guard let id = realID else { return false }
        return endowmentedArtIDsDefault.contains(id)
    }
    
    func switchFavorite() {
        guard let id = realID else { return }
        if isFavorite {
            favoriteArtIDsDefault.removeAll(id)
        } else {
            favoriteArtIDsDefault.append(id)
        }
    }
    
    func switchGathering() {
        guard let id = realID else { return }
        if isGathered {
            gatheredArtIDsDefault.removeAll(id)
            if isEndowmented {
                switchEndowment()
            }
        } else {
            gatheredArtIDsDefault.append(id)
        }
    }
    
    func switchEndowment() {
        guard let id = realID else { return }
        if isEndowmented {
            endowmentedArtIDsDefault.removeAll(id)
        } else {
            endowmentedArtIDsDefault.append(id)
            if !isGathered {
                switchGathering()
            }
        }
    }
}

extension Fossil {
    
    static var sampleArt: Fossil = .init()
}
