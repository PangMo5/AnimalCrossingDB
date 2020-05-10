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
            .init(view: CollectibleListView(viewModel: .init(style: .forYou)), title: "For You", image: "heart.fill"),
            .init(view: CollectibleListView(viewModel: .init(style: .all)), title: "채집물", image: "archivebox.fill"),
            .init(view: FossilListView(viewModel: .init()), title: "화석", image: "flame.fill"),
            .init(view: ArtListView(viewModel: .init()), title: "미술품", image: "photo.fill")
        ])
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
