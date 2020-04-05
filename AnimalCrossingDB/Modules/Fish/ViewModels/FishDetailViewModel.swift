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
import SwiftEntryKit

extension DefaultsKeys {
    var favoriteFishIDs: DefaultsKey<[Int]> { return .init("favoriteFishIDs", defaultValue: []) }
    var gatheredFishIDs: DefaultsKey<[Int]> { return .init("gatheredFishIDs", defaultValue: []) }
    var endowmentedFishIDs: DefaultsKey<[Int]> { return .init("endowmentedFishIDs", defaultValue: []) }
}

final class FishDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteFishIDs)
    fileprivate var favoriteFishIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredFishIDs)
    fileprivate var gatheredFishIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedFishIDs)
    fileprivate var endowmentedFishIDsDefault: [Int]
    
    var fish: Fish
    
    @Published var isFavorite: Bool = false
    @Published var isGathered: Bool = false
    @Published var isEndowmented: Bool = false
    
    init(fish: Fish) {
        self.fish = fish
        updateFavorite()
        updateGathering()
        updateEndowment()
        
        Refresher.shared.collectibleFlagableRefreshSubject.sink { [weak self] _ in
            self?.updateFavorite()
            self?.updateGathering()
            self?.updateEndowment()
        }.store(in: &disposables)
    }
    
    func switchFavorite() {
        guard let id = fish.id else { return }
        if isFavorite {
            favoriteFishIDsDefault.removeAll(id)
        } else {
            favoriteFishIDsDefault.append(id)
        }
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        guard let id = fish.id else { return }
        if isGathered {
            gatheredFishIDsDefault.removeAll(id)
            if isEndowmented {
                switchEndowment()
            }
        } else {
            gatheredFishIDsDefault.append(id)
        }
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        guard let id = fish.id else { return }
        if isEndowmented {
            endowmentedFishIDsDefault.removeAll(id)
        } else {
            endowmentedFishIDsDefault.append(id)
            if !isGathered {
                switchGathering()
            }
        }
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = fish.id else { return }
        isFavorite = favoriteFishIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = fish.id else { return }
        isGathered = gatheredFishIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = fish.id else { return }
        isEndowmented = endowmentedFishIDsDefault.contains(id)
    }
}
