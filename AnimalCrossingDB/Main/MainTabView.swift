//
//  MainTabView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FishListView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text("고기")
            }
            InsectListView()
                .tabItem {
                    Image(systemName: "ant.fill")
                    Text("곤충")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
