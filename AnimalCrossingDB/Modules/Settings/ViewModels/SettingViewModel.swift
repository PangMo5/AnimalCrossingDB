//
//  SettingViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
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
    
    var enabledBookmarkPush: DefaultsKey<Bool> { return .init("enabledBookmarkPush", defaultValue: true) }
    var hemisphere: DefaultsKey<Hemisphere> { return .init("hemisphere", defaultValue: .north) }
}

final class SettingViewModel: ObservableObject {

    enum URL {
        case github
        case blog
        case gebob
        
        var url: Foundation.URL {
            switch self {
            case .github:
                return Foundation.URL(string: "https://pangmo5.dev")!
            case .blog:
                return Foundation.URL(string: "https://blog.pangmo5.dev")!
            case .gebob:
                return Foundation.URL(string: "https://gebob123.wordpress.com")!
            }
        }
    }
    
    private var disposables = Set<AnyCancellable>()
    
    @SwiftyUserDefault(keyPath: \.enabledBookmarkPush)
    fileprivate var enabledBookmarkPushDefault: Bool
    
    @SwiftyUserDefault(keyPath: \.hemisphere)
    fileprivate var hemisphereDefault: Hemisphere
    
    @Published
    var enabledBookmarkPush = false
    
    @Published
    var hemisphere: Hemisphere = .north
    
    init() {
        updateHemisphere()
        enabledBookmarkPush = enabledBookmarkPushDefault
        
        $enabledBookmarkPush.dropFirst(2).sink(receiveValue: updateEnabledBookmarkPush(flag:)).store(in: &disposables)
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url.url)
    }
    
    func switchHemisphere() {
        hemisphereDefault = hemisphereDefault == .north ? .south : .north
        updateHemisphere()
        StorageManager.shared.fetchStaticData { _ in
            Refresher.shared.collectibleFlagableRefreshSubject.send(true)
        }
    }
    
    fileprivate func updateHemisphere() {
        hemisphere = hemisphereDefault
    }
    
    fileprivate func updateEnabledBookmarkPush(flag: Bool) {
//        enabledBookmarkPushDefault = flag
//        if flag {
//            PushManager.shared.scheuleAllPush()
//        } else {
//            PushManager.shared.removeAllPendingPush()
//        }
    }
}
