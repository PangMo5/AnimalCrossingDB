//
//  FossilDetailViewModel.swift
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

final class FossilDetailViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.favoriteFossilIDs)
    fileprivate var favoriteFossilIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.gatheredFossilIDs)
    fileprivate var gatheredFossilIDsDefault: [Int]
    @SwiftyUserDefault(keyPath: \.endowmentedFossilIDs)
    fileprivate var endowmentedFossilIDsDefault: [Int]
    
    var fossil: Fossil
    
    @Published var isFavorite: Bool = false
    @Published var isGathered: Bool = false
    @Published var isEndowmented: Bool = false
    
    init(fossil: Fossil) {
        self.fossil = fossil
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
        fossil.switchFavorite()
        updateFavorite()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchGathering() {
        fossil.switchGathering()
        updateGathering()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    func switchEndowment() {
        fossil.switchEndowment()
        updateEndowment()
        Refresher.shared.collectibleFlagableRefreshSubject.send(true)
    }
    
    fileprivate func updateFavorite() {
        guard let id = fossil.realID else { return }
        isFavorite = favoriteFossilIDsDefault.contains(id)
    }
    
    fileprivate func updateGathering() {
        guard let id = fossil.realID else { return }
        isGathered = gatheredFossilIDsDefault.contains(id)
    }
    
    fileprivate func updateEndowment() {
        guard let id = fossil.realID else { return }
        isEndowmented = endowmentedFossilIDsDefault.contains(id)
    }
}
