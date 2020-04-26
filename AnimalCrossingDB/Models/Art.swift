//
//  Art.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import UIKit

struct Art: Codable, Identifiable {
    
    var id: String {
        "\(realID ?? 0)_art"
    }
    var realID: Int?
    var name: String?
    var info: String?
}

extension Art {
    
    enum CodingKeys: String, CodingKey {
        case realID = "id"
        case name
        case info
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
