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
                .gridStyle(columns: 2)
                .resignKeyboardOnDragGesture()
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
                UIApplication.shared.endEditing(true)
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
                HStack {
                    Image(systemName: "bookmark.fill")
                        .font(.caption)
                        .foregroundColor(Color(art.isFavorite ? .label : .gray) )
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(Color(art.isGathered ? .label : .gray) )
                    Image(uiImage: UIImage(named: "owl.fill")!.withRenderingMode(.alwaysTemplate))
                        .resizable()
                        .frame(width: 11, height: 11)
                        .colorMultiply(Color(art.isEndowmented ? .label : .gray) )
                }
                .padding([.leading, .trailing], 6)
                Text(art.name ?? "")
                    .font(.headline)
                    .padding([.leading, .trailing], 6)
                    .fixedSize(horizontal: false, vertical: true)
                Text("(\(art.realName ?? ""))")
                    .font(.footnote)
                    .padding([.leading, .trailing], 6)
                    .fixedSize(horizontal: false, vertical: true)
                Text("- \(art.artist ?? "")")
                    .font(.footnote)
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
