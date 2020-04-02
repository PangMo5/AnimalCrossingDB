//
//  InsectListViewModel.swift
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
    var insectFilterMonth: DefaultsKey<Int?> { return .init("insectFilterMonth", defaultValue: Date().month) }
}

final class InsectListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.insectFilterMonth)
    fileprivate var filterMonthDefault: Int?
    
    @Published var filterMonth: Int? {
        didSet {
            filterMonthDefault = filterMonth
        }
    }
    @Published var searchText = ""
    
    @Published var availableInsectList = [Insect]()
    @Published var disavailableInsectList = [Insect]()
    
    init() {
        let sortedInsectList = StorageManager.shared.insectListSubject
            .map { $0.sorted { ($0.id ?? 0) > ($1.id ?? 0) } }
        
        let filteredInsectList = Publishers.CombineLatest3(sortedInsectList, $searchText, $filterMonth)
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
        
        filteredInsectList
            .map { $0.filter(\.isAvailable) }
            .assign(to: \.availableInsectList, on: self)
            .store(in: &disposables)
        
        filteredInsectList
            .map { $0.filter { !$0.isAvailable } }
            .assign(to: \.disavailableInsectList, on: self)
            .store(in: &disposables)
    }
}
