//
//  FossilListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct FossilListView: View {
    
    @State private var isModalSettingView = false
    @State private var isModalFilterView = false
    
    @ObservedObject var viewModel: FossilListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: self.$viewModel.searchText)
                List(viewModel.fossilList) {
                    FossilListCellView(fossil: $0)
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .resignKeyboardOnDragGesture()
            }
            .navigationBarTitle("화석")
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
                    if self.viewModel.fossilFilter.isEnableFilter() {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    } else {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }.sheet(isPresented: self.$isModalFilterView) {
                    FossilFilterView(viewModel: .init(filter: self.viewModel.fossilFilter))
            })
        }
    }
}

struct FossilListCellView: View {
    
    var fossil: Fossil
    
    var body: some View {
        NavigationLink(destination: FossilDetailView(viewModel: .init(fossil: fossil))) {
            HStack {
                Image(uiImage: fossil.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .font(.caption)
                            .foregroundColor(Color(fossil.isFavorite ? .label : .gray) )
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(fossil.isGathered ? .label : .gray) )
                        Image(uiImage: UIImage(named: "owl.fill")!.withRenderingMode(.alwaysTemplate))
                            .resizable()
                            .frame(width: 11, height: 11)
                            .colorMultiply(Color(fossil.isEndowmented ? .label : .gray) )
                    }
                    Text(fossil.name ?? "")
                        .bold()
                    Text("(\(fossil.enName ?? ""))")
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "bitcoinsign.circle")
                            .font(.footnote)
                        Text(fossil.price ?? "")
                            .font(.footnote)
                            .bold()
                    }
                }
            }.contextMenu {
                fossil.contextMenuContents()
            }
        }
    }
}
