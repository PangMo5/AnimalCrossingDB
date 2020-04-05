//
//  FishListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct CollectibleListView: View {
    
    @State private var segmentIndex = 0
    @State private var isModalSettingView = false
    @State private var showingSortSheet = false
    @State private var showingFilterSheet = false
    
    @ObservedObject var viewModel: CollectibleListViewModel
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    SearchBar(text: self.$viewModel.searchText)
                    if self.viewModel.style == .all {
                        self.allView
                            .listStyle(GroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            .resignKeyboardOnDragGesture()
                    } else {
                        self.forYouView
                            .listStyle(GroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            .resignKeyboardOnDragGesture()
                    }
                }
                .navigationBarTitle(self.viewModel.style.navigationTitle)
                .navigationBarItems(leading:
                    HStack {
                        Button(action: {
                            self.isModalSettingView = true
                        }) {
                            Image(systemName: "gear")
                        }.sheet(isPresented: self.$isModalSettingView) {
                            SettingView()
                        }
                        Picker(selection: self.$segmentIndex, label: Text("Picker")) {
                            Text("고기")
                                .tag(0)
                            Text("곤충")
                                .tag(1)
                        }
                        .frame(width: 130)
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, (geometry.size.width / 2.0) - 108)
                    }, trailing:
                    HStack {
                        Button(action: {
                            self.showingSortSheet = true
                        }) {
                            if self.viewModel.sortType == .id {
                                Image(systemName: "arrow.up.arrow.down.circle")
                            } else {
                                Image(systemName: "arrow.up.arrow.down.circle.fill")
                            }
                        }.actionSheet(isPresented: self.$showingSortSheet) {
                            var buttons = CollectibleListViewModel.SortType.allCases.compactMap { sort -> ActionSheet.Button? in
                                if sort == self.viewModel.sortType {
                                    return nil
                                } else {
                                    return ActionSheet.Button.default(Text(sort.localized)) {
                                        self.viewModel.sortType = sort
                                    }
                                }
                            }
                            buttons.append(.cancel())
                            return ActionSheet(title: Text("정렬 방법을 선택해주세요."), buttons: buttons)
                        }
                        Button(action: {
                            self.showingFilterSheet = true
                        }) {
                            if self.viewModel.filterMonth == nil {
                                Text("전체")
                            } else {
                                Text("\(self.viewModel.filterMonth ?? 0)월")
                            }
                        }.actionSheet(isPresented: self.$showingFilterSheet) {
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
                })
            }
        }
    }
}

extension CollectibleListView {
    
    var allView: some View {
        List {
            Section(header: Text("채집 가능").font(.headline).bold()) {
                if self.segmentIndex == 0 {
                    ForEach(self.viewModel.availableFishList) {
                        FishListCellView(fish: $0)
                    }
                } else {
                    ForEach(self.viewModel.availableInsectList) {
                        InsectListCellView(insect: $0)
                    }
                }
            }
            Section(header: Text("채집 불가능").font(.headline).bold()) {
                if self.segmentIndex == 0 {
                    ForEach(self.viewModel.disavailableFishList) {
                        FishListCellView(fish: $0)
                    }
                } else {
                    ForEach(self.viewModel.disavailableInsectList) {
                        InsectListCellView(insect: $0)
                    }
                }
            }
        }
    }
    
    var forYouView: some View {
        List {
            Section(header: Text("북마크").font(.headline).bold()) {
                if self.segmentIndex == 0 {
                    ForEach(self.viewModel.favoritedFishList) {
                        FishListCellView(fish: $0)
                    }
                } else {
                    ForEach(self.viewModel.favoritedInsectList) {
                        InsectListCellView(insect: $0)
                    }
                }
            }
            Section(header: Text("기증됨").font(.headline).bold()) {
                if self.segmentIndex == 0 {
                    ForEach(self.viewModel.endowmentedFishList) {
                        FishListCellView(fish: $0)
                    }
                } else {
                    ForEach(self.viewModel.endowmentedInsectList) {
                        InsectListCellView(insect: $0)
                    }
                }
            }
            Section(header: Text("채집됨").font(.headline).bold()) {
                if self.segmentIndex == 0 {
                    ForEach(self.viewModel.gatheredFishList) {
                        FishListCellView(fish: $0)
                    }
                } else {
                    ForEach(self.viewModel.gatheredInsectList) {
                        InsectListCellView(insect: $0)
                    }
                }
            }
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CollectibleListView(viewModel: .init(style: .forYou))
            CollectibleListView(viewModel: .init(style: .all))
        }
    }
}

struct FishListCellView: View {
    
    var fish: Fish
    
    var body: some View {
        NavigationLink(destination: FishDetailView(viewModel: .init(fish: fish))) {            
            HStack {
                Image(uiImage: fish.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading) {
                    Text(fish.name ?? "")
                        .bold()
                    Text("(\(fish.englishName ?? ""))")
                        .font(.footnote)
                }.foregroundColor(.init(fish.isAvailable ? .label : .gray))
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Group {
                            Image(systemName: "clock")
                                .font(.footnote)
                            Text(fish.availableTime ?? "")
                                .font(.footnote)
                                .bold()
                        }.foregroundColor(Color(fish.hourList[safe: Date().hour] == true ? .label : .red) )
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
                }.foregroundColor(.init(insect.isAvailable ? .label : .gray))
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Group {
                            Image(systemName: "clock")
                                .font(.footnote)
                            Text(insect.availableTime ?? "")
                                .font(.footnote)
                                .bold()
                        }.foregroundColor(Color(insect.hourList[safe: Date().hour] == true ? .label : .red) )
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
