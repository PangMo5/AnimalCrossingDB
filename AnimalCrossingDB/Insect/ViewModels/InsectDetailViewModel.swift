//
//  InsectDetailViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwifterSwift
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteInsectIDs: DefaultsKey<[Int]> { return .init("favoriteInsectIDs", defaultValue: []) }
}

final class InsectDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteInsectIDs)
    fileprivate var favoriteInsectIDsDefault: [Int]
    
    var insect: Insect
    
    @Published var isFavorite: Bool = false
    
    init(insect: Insect) {
        self.insect = insect
        updateFavorite()
    }
    
    func switchFavorite() {
        guard let id = insect.id else { return }
        if isFavorite {
            favoriteInsectIDsDefault.removeAll(id)
        } else {
            favoriteInsectIDsDefault.append(id)
        }
        updateFavorite()
    }
    
    fileprivate func updateFavorite() {
        guard let id = insect.id else { return }
        isFavorite = favoriteInsectIDsDefault.contains(id)
    }
}
