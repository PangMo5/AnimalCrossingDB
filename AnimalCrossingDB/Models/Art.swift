//
//  Art.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

struct Art: Gatherable, Codable, Identifiable {

    enum TypeEnum: String, Codable {
        case picture = "명화"
        case piece = "조각"
    }
    
    var id: String {
        "\(realID ?? 0)_art"
    }
    var realID: Int?
    var type: TypeEnum?
    var name: String?
    var realName: String?
    var artist: String?
    var info: String?
    var advice: String?
    
    @SwiftyUserDefault(keyPath: \.favoriteArtIDs)
    fileprivate var favoriteArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredArtIDs)
    fileprivate var gatheredArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedArtIDs)
    fileprivate var endowmentedArtIDsDefault: [Int]
}


extension Art {
    
    enum CodingKeys: String, CodingKey {
        case realID = "id"
        case type
        case name
        case realName
        case artist
        case info
        case advice
    }
}

extension Art {
    
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

extension Art {
    
    var curioImage: UIImage? {
        guard let id = realID,
            let image = StorageManager.shared.artImageList[id]?.first else { return nil }
        return image
    }
    
    var fakeImages: [UIImage] {
        guard let id = realID,
            let images = StorageManager.shared.artImageList[id]?.dropFirst() else { return [] }
        return Array(images)
    }
}

extension Art {
    
    static var sampleArt: Art = .init(realID: 0, name: "이름", info: "정보")
}

extension UIImage: Identifiable {
    
}
