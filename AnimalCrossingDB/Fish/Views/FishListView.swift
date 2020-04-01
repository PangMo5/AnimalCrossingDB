//
//  FishListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct FishListView: View {
    
    @ObservedObject var viewModel = FishListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    Section(header: Text("채집 가능")) {
                        ForEach(self.viewModel.availableFishList) {
                            FishListCellView(fish: $0)
                        }
                    }
                    Section(header: Text("채집 불가능")) {
                        ForEach(self.viewModel.disavailableFishList) {
                            FishListCellView(fish: $0)
                        }
                    }
                }.listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .resignKeyboardOnDragGesture()
            }
            .navigationBarTitle("고기")
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}

struct FishListCellView: View {
    
    var fish: Fish
    
    var body: some View {
        HStack {
            FBURLImage(url: "fish/\(fish.id ?? 0).png")
                .frame(width: 64, height: 64)
            VStack(alignment: .leading) {
                Text(fish.name ?? "")
                    .bold()
                Text("(\(fish.englishName ?? ""))")
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "clock")
                        .font(.footnote)
                    Text(fish.availableTime ?? "")
                        .font(.footnote)
                        .bold()
                }
                HStack {
                    Image(systemName: "location")
                        .font(.footnote)
                    Text(fish.area?.localized ?? "")
                        .font(.footnote)
                        .bold()
                }
            }
        }
    }
}
