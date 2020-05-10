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
    
    var id: String {
        "\(realID ?? 0)_fossil"
    }
    var realID: Int?
    var setID: Int?
    var name: String?
    var enName: String?
    var setName: String?
    var enSetName: String?
    var price: String?
    
    @SwiftyUserDefault(keyPath: \.favoriteFossilIDs)
    fileprivate var favoriteFossilIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredFossilIDs)
    fileprivate var gatheredFossilIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedFossilIDs)
    fileprivate var endowmentedFossilIDsDefault: [Int]
}

extension Fossil {
    
    enum CodingKeys: String, CodingKey {
        case realID = "id"
        case setID
        case name
        case enName
        case setName
        case enSetName
        case price
    }
}

extension Fossil {
    
    var image: UIImage {
        StorageManager.shared.fossilImageList[realID ?? 0] ?? UIImage(systemName: "flame.fill")!
    }
}

extension Fossil {
    
    var isFavorite: Bool {
        guard let id = realID else { return false }
        return favoriteFossilIDsDefault.contains(id)
    }
    
    var isGathered: Bool {
        guard let id = realID else { return false }
        return gatheredFossilIDsDefault.contains(id)
    }
    
    var isEndowmented: Bool {
        guard let id = realID else { return false }
        return endowmentedFossilIDsDefault.contains(id)
    }
    
    func switchFavorite() {
        guard let id = realID else { return }
        if isFavorite {
            favoriteFossilIDsDefault.removeAll(id)
        } else {
            favoriteFossilIDsDefault.append(id)
        }
    }
    
    func switchGathering() {
        guard let id = realID else { return }
        if isGathered {
            gatheredFossilIDsDefault.removeAll(id)
            if isEndowmented {
                switchEndowment()
            }
        } else {
            gatheredFossilIDsDefault.append(id)
        }
    }
    
    func switchEndowment() {
        guard let id = realID else { return }
        if isEndowmented {
            endowmentedFossilIDsDefault.removeAll(id)
        } else {
            endowmentedFossilIDsDefault.append(id)
            if !isGathered {
                switchGathering()
            }
        }
    }
}

extension Fossil {
    
    static var sampleFossil: Fossil = .init()
}
