//
//  InsectListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct InsectListView: View {
    
    @State private var isModalSettingView = false
    @State private var showingSheet = false
    
    @ObservedObject var viewModel = InsectListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    Section(header: Text("채집 가능").font(.headline).bold()) {
                        ForEach(self.viewModel.availableInsectList) {
                            InsectListCellView(insect: $0)
                        }
                    }
                    Section(header: Text("채집 불가능").font(.headline).bold()) {
                        ForEach(self.viewModel.disavailableInsectList) {
                            InsectListCellView(insect: $0)
                        }
                    }
                }.listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .resignKeyboardOnDragGesture()
            }
            .navigationBarTitle("채집보벳따우")
            .navigationBarItems(leading:Button(action: {
                self.isModalSettingView = true
            }) {
                Image(systemName: "gear")
            }.sheet(isPresented: $isModalSettingView) {
                SettingView()
                }, trailing: Button(action: {
                    self.showingSheet = true
                }) {
                    if self.viewModel.filterMonth == nil {
                        Text("전체")
                    } else {
                        Text("\(self.viewModel.filterMonth ?? 0)월")
                    }
            })
                .actionSheet(isPresented: $showingSheet) {
                    var buttons = [
                        ActionSheet.Button.default(Text("전체")) {
                            self.viewModel.filterMonth = nil
                        }
                    ]
                    buttons.append(contentsOf: (1...12).compactMap(Int.init).map { month in ActionSheet.Button.default(Text("\(month)월")) {
                        self.viewModel.filterMonth = month
                        }
                    })
                    buttons.append(.cancel())
                    return ActionSheet(title: Text("필러링 할 날짜를 선택해주세요."), buttons: buttons)
            }
        }
    }
}

struct InsectListView_Previews: PreviewProvider {
    static var previews: some View {
        InsectListView()
    }
}

struct InsectListCellView: View {
    
    var insect: Insect
    
    var body: some View {
        NavigationLink(destination: InsectDetailView(viewModel: .init(insect: insect))) {
            HStack {
                Image(uiImage: insect.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading) {
                    Text(insect.name ?? "")
                        .bold()
                    Text("(\(insect.englishName ?? ""))")
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "clock")
                            .font(.footnote)
                        Text(insect.availableTime ?? "")
                            .font(.footnote)
                            .bold()
                    }
                    HStack {
                        Image(systemName: "location")
                            .font(.footnote)
                        Text(insect.area?.rawValue ?? "")
                            .font(.footnote)
                            .bold()
                    }
                }
            }
        }
    }
}
