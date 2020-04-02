//
//  MainTabView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    @State var currentTab = 0
    
    var body: some View {
        UIKitTabView([
            .init(view: FishListView(), title: "고기", image: "tortoise.fill"),
            .init(view: InsectListView(), title: "곤충", image: "ant.fill")
        ])
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
