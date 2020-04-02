//
//  FishDetailViewModel.swift
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
    var favoriteFishIDs: DefaultsKey<[Int]> { return .init("favoriteFishIDs", defaultValue: []) }
}

final class FishDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteFishIDs)
    fileprivate var favoriteFishIDsDefault: [Int]
    
    var fish: Fish
    
    @Published var isFavorite: Bool = false
    
    init(fish: Fish) {
        self.fish = fish
        updateFavorite()
    }
    
    func switchFavorite() {
        guard let id = fish.id else { return }
        if isFavorite {
            favoriteFishIDsDefault.removeAll(id)
        } else {
            favoriteFishIDsDefault.append(id)
        }
        updateFavorite()
    }
    
    fileprivate func updateFavorite() {
        guard let id = fish.id else { return }
        isFavorite = favoriteFishIDsDefault.contains(id)
    }
}
