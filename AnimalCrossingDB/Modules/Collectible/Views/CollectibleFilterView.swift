//
//  CollectibleFilterView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct CollectibleFilterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CollectibleFilterViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("상태")) {
                    Toggle(isOn: $viewModel.filter.onlyFavorite) {
                        Text("북마크한 채집물만")
                    }
                    Toggle(isOn: $viewModel.filter.onlyGathered) {
                        Text("채집한 채집물만")
                    }
                    Toggle(isOn: $viewModel.filter.onlyEndowmented) {
                        Text("기증한 채집물만")
                    }
                }
                Section(header: Text("채집물")) {
                    if viewModel.fromFish {
                        HStack {
                            Text("크기")
                            Spacer()
                        }
                    }
                    HStack {
                        Text("출현 장소")
                        Spacer()
                    }
                }
                Section(header: Text("시간")) {
                    HStack {
                        Text("출현 시기")
                        Spacer()
                    }
                }
            }.listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle(Text("필터"))
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                }, trailing: Button(action: {
                    Refresher.shared.collectibleFilterRefreshSubject.send(self.viewModel.filter)
                }) {
                    Text("적용")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CollectibleFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CollectibleFilterView(viewModel: .init(fromFish: true, filter: .init()))
    }
}
