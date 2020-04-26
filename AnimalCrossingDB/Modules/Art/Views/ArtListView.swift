//
//  ArtListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct ArtListView: View {
    
    @State private var isModalSettingView = false
    @State private var isModalFilterView = false
    
    @ObservedObject var viewModel: ArtListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: self.$viewModel.searchText)
                WaterfallGrid(self.viewModel.artList) { art in
                    ArtCellView(art: art)
                }
                .gridStyle(columnsInPortrait: 2, columnsInLandscape: 3)
                .padding([.leading, .trailing])
            }
            .navigationBarTitle("미술품")
            .navigationBarItems(leading:
                Button(action: {
                    self.isModalSettingView = true
                }) {
                    Image(systemName: "gear")
                }.sheet(isPresented: self.$isModalSettingView) {
                    SettingView()
            }, trailing: Button(action: {
                self.isModalFilterView = true
            }) {
                if self.viewModel.artFilter.isEnableFilter() {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                } else {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }.sheet(isPresented: self.$isModalFilterView) {
                ArtFilterView(viewModel: .init(filter: self.viewModel.artFilter))
            })
        }
    }
}

struct ArtCellView: View {
    
    var art: Art
    
    var body: some View {
        NavigationLink(destination: ArtDetailView(viewModel: .init(art: art))) {
            VStack(alignment: .leading) {
                if art.curioImage != nil {
                    Image(uiImage: art.curioImage!)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                Text(art.name ?? "")
                    .font(.headline)
                    .padding([.leading, .trailing, .bottom], 6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(4)
            .contextMenu {
                art.contextMenuContents()
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ArtListView_Previews: PreviewProvider {
    static var previews: some View {
        ArtListView(viewModel: .init())
    }
}
