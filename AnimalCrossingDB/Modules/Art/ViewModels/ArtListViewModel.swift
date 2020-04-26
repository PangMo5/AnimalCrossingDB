//
//  ArtListViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwiftyUserDefaults

extension DefaultsKeys {
    var artFilter: DefaultsKey<ArtFilter> { return .init("artFilter", defaultValue: .init()) }
}

final class ArtListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.artFilter)
    fileprivate var artFilterDefault: ArtFilter
    
    @Published var artFilter = ArtFilter() {
        didSet {
            artFilterDefault = artFilter
        }
    }
    
    @Published fileprivate var refresh = false
    
    @Published var artList = [Art]()
    
    @Published var searchText = ""
    
    init() {
        Refresher.shared.collectibleFlagableRefreshSubject.assign(to: \.refresh, on: self).store(in: &disposables)
        
        Refresher.shared.artFilterRefreshSubject.assign(to: \.artFilter, on: self).store(in: &disposables)
        
        artFilter = artFilterDefault
        
        Publishers.CombineLatest4(StorageManager.shared.artListSubject,
                                  $refresh,
                                  $searchText,
                                  $artFilter)
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.global(qos: .background))
            .map { $0.0.sorted(by: \.id).filtered(searchText: $0.2, filter: $0.3) }
            .print()
            .assign(to: \.artList, on: self)
            .store(in: &disposables)
    }
}

extension Array where Element == Art {
    
    func filtered(searchText: String, filter: ArtFilter) -> [Element] {
        let filtered = gatherableFiltered(filter: filter)
        return filtered.filter {
            let filtered = ($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
                || ($0.info?.lowercased().contains(searchText.lowercased()) ?? false)
                || searchText.isEmpty
            return filtered
        }
    }
}
