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

final class InsectListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    
    @Published var availableInsectList = [Insect]()
    @Published var disavailableInsectList = [Insect]()
    
    init() {
        let sortedInsectList = StorageManager.shared.insectListSubject
            .map { $0.sorted { ($0.id ?? 0) > ($1.id ?? 0) } }
        
        let filteredInsectList = Publishers.CombineLatest($searchText, sortedInsectList)
            .map { text, fishList in
                fishList.filter {
                    ($0.name?.lowercased().contains(text.lowercased()) ?? false)
                        || ($0.englishName?.lowercased().contains(text.lowercased()) ?? false)
                        || text.isEmpty
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
