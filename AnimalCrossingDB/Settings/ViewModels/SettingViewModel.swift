//
//  SettingViewModel.swift
//  AnimeRadio
//
//  Created by Shirou on 2020/02/22.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwiftyUserDefaults

enum Hemisphere: String, DefaultsSerializable {
    case north
    case south
    
    var localized: String {
        switch self {
        case .north:
            return "북반구"
        case .south:
            return "남반구"
        }
    }
}

extension DefaultsKeys {
    var hemisphere: DefaultsKey<Hemisphere> { return .init("hemisphere", defaultValue: .north) }
}

final class SettingViewModel: ObservableObject {

    enum URL {
        case github
        case blog
        
        var url: Foundation.URL {
            switch self {
            case .github:
                return Foundation.URL(string: "https://pangmo5.dev")!
            case .blog:
                return Foundation.URL(string: "https://blog.pangmo5.dev")!
            }
        }
    }
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.hemisphere)
    fileprivate var hemisphereDefault: Hemisphere
    
    @Published
    var hemisphere: Hemisphere = .north
    
    init() {
        updateHemisphere()
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url.url)
    }
    
    func switchHemisphere() {
        hemisphereDefault = hemisphereDefault == .north ? .south : .north
        updateHemisphere()
        StorageManager.shared.fetchStaticData { _ in }
    }
    
    fileprivate func updateHemisphere() {
        hemisphere = hemisphereDefault
    }
}
