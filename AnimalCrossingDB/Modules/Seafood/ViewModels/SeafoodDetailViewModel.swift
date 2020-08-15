//
//  SeafoodDetailViewModel.swift
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

final class SeafoodDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteSeafoodIDs)
    fileprivate var favoriteSeafoodIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredSeafoodIDs)
    fileprivate var gatheredSeafoodIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedSeafoodIDs)
    fileprivate var endowmentedSeafoodIDsDefault: [Int]
    
    var seafood: Seafood
    
    @Published var isFavorite: Bool = false
    @Published var isGathered: Bool = false
    @Published var isEndowmented: Bool = false
    
    init(seafood: Seafood) {
        self.seafood = seafood
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
        seafood.switchFavorite()
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        seafood.switchGathering()
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        seafood.switchEndowment()
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = seafood.realID else { return }
        isFavorite = favoriteSeafoodIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = seafood.realID else { return }
        isGathered = gatheredSeafoodIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = seafood.realID else { return }
        isEndowmented = endowmentedSeafoodIDsDefault.contains(id)
    }
}
