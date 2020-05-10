//
//  FossilListViewModel.swift
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
    var fossilFilter: DefaultsKey<FossilFilter> { return .init("fossilFilter", defaultValue: .init()) }
}

final class FossilListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.fossilFilter)
    fileprivate var fossilFilterDefault: FossilFilter
    
    @Published var fossilFilter = FossilFilter() {
        didSet {
            fossilFilterDefault = fossilFilter
        }
    }
    
    @Published fileprivate var refresh = false
    
    @Published var fossilList = [Fossil]()
    
    @Published var searchText = ""
    
    init() {
        Refresher.shared.collectibleFlagableRefreshSubject.assign(to: \.refresh, on: self).store(in: &disposables)
        
        Refresher.shared.fossilFilterRefreshSubject.assign(to: \.fossilFilter, on: self).store(in: &disposables)
        
        fossilFilter = fossilFilterDefault
        
        Publishers.CombineLatest4(StorageManager.shared.fossilListSubject,
                                  $refresh,
                                  $searchText,
                                  $fossilFilter)
        .print()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.global(qos: .background))
            .map { $0.0.sorted(by: \.id).filtered(searchText: $0.2, filter: $0.3) }
            .assign(to: \.fossilList, on: self)
            .store(in: &disposables)
    }
}

extension Array where Element == Fossil {
    
    func filtered(searchText: String, filter: FossilFilter) -> [Element] {
        let filtered = gatherableFiltered(filter: filter)
        return filtered.filter {
            let filtered = ($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
                || ($0.enName?.lowercased().contains(searchText.lowercased()) ?? false)
                || searchText.isEmpty
            return filtered
        }
    }
}
