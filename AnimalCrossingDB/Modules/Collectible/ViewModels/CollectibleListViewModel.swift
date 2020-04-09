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
    var collectibleSortType: DefaultsKey<CollectibleListViewModel.SortType> { return .init("collectibleSortType", defaultValue: .id) }
}

final class CollectibleListViewModel: ObservableObject {
    
    enum Style: String {
        case all
        case forYou
        
        var navigationTitle: String {
            switch self {
            case .all:
                return "도감"
            case .forYou:
                return "For You"
            }
        }
    }
    
    enum SortType: String, DefaultsSerializable, CaseIterable {
        case id
        case lowerPrice
        case greaterPrice
        case time
        
        var localized: String {
            switch self {
            case .id:
                return "기본값"
            case .lowerPrice:
                return "가격 낮은 순"
            case .greaterPrice:
                return "가격 높은 순"
            case .time:
                return "시간 순"
            }
        }
    }
    
    var style: Style
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.fishFilterMonth)
    fileprivate var filterMonthDefault: Int?
    
    @SwiftyUserDefault(keyPath: \.collectibleSortType)
    fileprivate var sortTypeDefault: SortType
    
    @Published fileprivate var refresh = false
    
    @Published var sortType: SortType = .id {
        didSet {
            sortTypeDefault = sortType
        }
    }
    @Published var filterMonth: Int? {
        didSet {
            filterMonthDefault = filterMonth
        }
    }
    
    @Published var searchText = ""
    
    @Published var availableFishList = [Fish]()
    @Published var disavailableFishList = [Fish]()
    
    @Published var availableInsectList = [Insect]()
    @Published var disavailableInsectList = [Insect]()
    
    @Published var favoritedFishList = [Fish]()
    @Published var gatheredFishList = [Fish]()
    @Published var endowmentedFishList = [Fish]()
    
    @Published var favoritedInsectList = [Insect]()
    @Published var gatheredInsectList = [Insect]()
    @Published var endowmentedInsectList = [Insect]()
    
    init(style: Style) {
        self.style = style
        self.sortType = sortTypeDefault
        
        Refresher.shared.collectibleFlagableRefreshSubject.assign(to: \.refresh, on: self).store(in: &disposables)
        
        filterMonth = filterMonthDefault
        
        let sortedFishList = Publishers.CombineLatest(StorageManager.shared.fishListSubject, $sortType)
            .map { $0.0.sorted(sort: $0.1) }
        
        let filteredFishList = Publishers.CombineLatest4($refresh, sortedFishList, $searchText, $filterMonth)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .map { _, fishList, text, month in
                fishList.filtered(style: style).filtered(searchText: text, month: month).filtered(style: style)
        }
        
        filteredFishList
            .map { $0.filter(\.isAvailable) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.availableFishList, on: self)
            .store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { !$0.isAvailable } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.disavailableFishList, on: self).store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { $0.isFavorite } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.favoritedFishList, on: self).store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { $0.isGathered && !$0.isEndowmented } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.gatheredFishList, on: self).store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { $0.isEndowmented } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.endowmentedFishList, on: self).store(in: &disposables)
        
        let sortedInsectList = Publishers.CombineLatest(StorageManager.shared.insectListSubject, $sortType)
        .map { $0.0.sorted(sort: $0.1) }
        
        let filteredInsectList = Publishers.CombineLatest4($refresh, sortedInsectList, $searchText, $filterMonth)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .map { _, fishList, text, month in
                fishList.filtered(style: style).filtered(searchText: text, month: month)
        }
        
        filteredInsectList
            .map { $0.filter(\.isAvailable) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.availableInsectList, on: self)
            .store(in: &disposables)
        
        filteredInsectList
            .map { $0.filter { !$0.isAvailable } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.disavailableInsectList, on: self)
            .store(in: &disposables)
        
        filteredInsectList
            .map { $0.filter { $0.isFavorite } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.favoritedInsectList, on: self).store(in: &disposables)
        
        filteredInsectList
            .map { $0.filter { $0.isGathered && !$0.isEndowmented } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.gatheredInsectList, on: self).store(in: &disposables)
        
        filteredInsectList
            .map { $0.filter { $0.isEndowmented } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.endowmentedInsectList, on: self).store(in: &disposables)
    }
}

extension Array where Element: Collectible {
    
    func sorted(sort: CollectibleListViewModel.SortType) -> [Element] {
        sorted { lhs, rhs -> Bool in
            switch sort {
            case .id:
                return (lhs.realID ?? 0) < (rhs.realID ?? 0)
            case .lowerPrice:
                return (lhs.price ?? 0) < (rhs.price ?? 0)
            case .greaterPrice:
                return (lhs.price ?? 0) > (rhs.price ?? 0)
            case .time:
                return lhs.firstHour < rhs.firstHour
            }
        }
    }
    
    func filtered(style: CollectibleListViewModel.Style) -> [Element] {
        filter {
            (($0.isFavorite || $0.isGathered || $0.isEndowmented) && style == .forYou) || style == .all
        }
    }
    
    func filtered(searchText: String, month: Int?) -> [Element] {
        filter {
            var filtered = false
            filtered = ($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
                || ($0.englishName?.lowercased().contains(searchText.lowercased()) ?? false)
                || searchText.isEmpty
            if let month = month {
                filtered = ($0.monthList[safe: month - 1] ?? false) && filtered
            }
            return filtered
        }
    }
}
