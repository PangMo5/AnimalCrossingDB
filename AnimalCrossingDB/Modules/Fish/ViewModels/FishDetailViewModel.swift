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
        fish.switchFavorite()
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        fish.switchGathering()
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        fish.switchEndowment()
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = fish.realID else { return }
        isFavorite = favoriteFishIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = fish.realID else { return }
        isGathered = gatheredFishIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = fish.realID else { return }
        isEndowmented = endowmentedFishIDsDefault.contains(id)
    }
}
