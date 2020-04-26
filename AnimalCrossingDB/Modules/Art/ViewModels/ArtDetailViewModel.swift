//
//  ArtDetailViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwifterSwift
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteArtIDs: DefaultsKey<[Int]> { return .init("favoriteArtIDs", defaultValue: []) }
    var gatheredArtIDs: DefaultsKey<[Int]> { return .init("gatheredArtIDs", defaultValue: []) }
    var endowmentedArtIDs: DefaultsKey<[Int]> { return .init("endowmentedArtIDs", defaultValue: []) }
}

final class ArtDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteArtIDs)
    fileprivate var favoriteArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredArtIDs)
    fileprivate var gatheredArtIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedArtIDs)
    fileprivate var endowmentedArtIDsDefault: [Int]
    
    var art: Art
    
    @Published var isFavorite: Bool = false
    @Published var isGathered: Bool = false
    @Published var isEndowmented: Bool = false
    
    init(art: Art) {
        self.art = art
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
        art.switchFavorite()
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        art.switchGathering()
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        art.switchEndowment()
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = art.realID else { return }
        isFavorite = favoriteArtIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = art.realID else { return }
        isGathered = gatheredArtIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = art.realID else { return }
        isEndowmented = endowmentedArtIDsDefault.contains(id)
    }
}
