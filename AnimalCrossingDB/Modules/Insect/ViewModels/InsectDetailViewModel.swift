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
    var gatheredInsectIDs: DefaultsKey<[Int]> { return .init("gatheredInsectIDs", defaultValue: []) }
    var endowmentedInsectIDs: DefaultsKey<[Int]> { return .init("endowmentedInsectIDs", defaultValue: []) }
}

final class InsectDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteInsectIDs)
    fileprivate var favoriteInsectIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredInsectIDs)
    fileprivate var gatheredInsectIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedInsectIDs)
    fileprivate var endowmentedInsectIDsDefault: [Int]
    
    var insect: Insect
    
    @Published var isFavorite: Bool = false
    @Published var isGathered: Bool = false
    @Published var isEndowmented: Bool = false
    
    init(insect: Insect) {
        self.insect = insect
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
        insect.switchFavorite()
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        insect.switchGathering()
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        insect.switchEndowment()
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = insect.realID else { return }
        isFavorite = favoriteInsectIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = insect.realID else { return }
        isGathered = gatheredInsectIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = insect.realID else { return }
        isEndowmented = endowmentedInsectIDsDefault.contains(id)
    }
}
