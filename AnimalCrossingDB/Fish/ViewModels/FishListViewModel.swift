//
//  FishListViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwifterSwift
import SwiftyUserDefaults

extension DefaultsKeys {
    var fishFilterMonth: DefaultsKey<Int?> { return .init("fishFilterMonth", defaultValue: Date().month) }
}

final class FishListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.fishFilterMonth)
    fileprivate var filterMonthDefault: Int?
    
    @Published var filterMonth: Int? {
        didSet {
            filterMonthDefault = filterMonth
        }
    }
    
    @Published var searchText = ""
    
    @Published var availableFishList = [Fish]()
    @Published var disavailableFishList = [Fish]()
    
    init() {
        filterMonth = filterMonthDefault
        
        let sortedFishList = StorageManager.shared.fishListSubject
            .map { $0.sorted { ($0.id ?? 0) > ($1.id ?? 0) } }
        
        let filteredFishList = Publishers.CombineLatest3(sortedFishList, $searchText, $filterMonth)
            .map { fishList, text, month in
                fishList.filter {
                    var filtered = false
                    filtered = ($0.name?.lowercased().contains(text.lowercased()) ?? false)
                        || ($0.englishName?.lowercased().contains(text.lowercased()) ?? false)
                        || text.isEmpty
                    if let month = month {
                        filtered = ($0.monthList[safe: month - 1] ?? false) && filtered
                    }
                    return filtered
                }
        }
        
        filteredFishList
            .map { $0.filter(\.isAvailable) }
            .assign(to: \.availableFishList, on: self)
            .store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { !$0.isAvailable } }
            .assign(to: \.disavailableFishList, on: self).store(in: &disposables)
    }
}
