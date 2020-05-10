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
    
    private var collectibleType: CollectibleType {
        if segmentIndex == 0 {
            return .fish
        } else {
            return .insect
        }
    }
    
    @State private var isModalSettingView = false
    @State private var showingSortSheet = false
    @State private var isModalFilterView = false
    
    @ObservedObject var viewModel: CollectibleListViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
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
                    self.leadingNavigationBarItems(geometry: geometry)
                    , trailing:
                    self.trailingNavigationBarItems
                )
            }
        }
    }
    
    func leadingNavigationBarItems(geometry: GeometryProxy) -> some View {
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
        }
    }
    
    var trailingNavigationBarItems: some View {
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
                self.isModalFilterView = true
                UIApplication.shared.endEditing(true)
            }) {
                if self.viewModel.collectibleFilter.isEnableFilter(fromFish: self.collectibleType == .fish) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                } else {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }.sheet(isPresented: self.$isModalFilterView) {
                CollectibleFilterView(viewModel: .init(fromFish: self.collectibleType == .fish, filter: self.viewModel.collectibleFilter))
            }
        }
    }
}

extension CollectibleListView {
    
    var allView: some View {
        List {
            Section(header: Text("채집 가능").font(.headline).bold()) {
                if self.collectibleType == .fish {
                    ForEach(self.viewModel.availableFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else {
                    ForEach(self.viewModel.availableInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                }
            }
            Section(header: Text("채집 불가능").font(.headline).bold()) {
                if self.collectibleType == .fish {
                    ForEach(self.viewModel.disavailableFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else {
                    ForEach(self.viewModel.disavailableInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                }
            }
        }
    }
    
    func achievementText(_ tuple: (Int, Int)) -> some View {
        Text("\(String(format: "%.2f", tuple.0.float / tuple.1.float * 100))% (\(tuple.0)/\(tuple.1))")
            .font(.headline).bold()
    }
    
    var forYouView: some View {
        List {
            Section(header: HStack {
                Text("\(collectibleType.localized) 채집 달성률:")
                    .font(.headline).bold()
                if self.collectibleType == .fish {
                    achievementText(self.viewModel.fishAchievement)
                } else {
                    achievementText(self.viewModel.insectAchievement)
                }
            }) {
                EmptyView()
            }
            Section(header: Text("\(DateManager.shared.currentDate.month)월까지 잡아야 하는 \(collectibleType.localized)").font(.headline).bold()) {
                if self.collectibleType == .fish && !self.viewModel.lastMonthFishList.isEmpty {
                    ForEach(self.viewModel.lastMonthFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else if self.collectibleType == .insect && !self.viewModel.lastMonthInsectList.isEmpty {
                    ForEach(self.viewModel.lastMonthInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                } else if viewModel.collectibleFilter.isEnableFilter(fromFish: collectibleType == .fish) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                            Text("필터에 맞는 \(collectibleType.localized)가 없습니다.")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding()
                } else {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.largeTitle)
                            Text("\(DateManager.shared.currentDate.month)월까지 잡아야 하는\n모든 \(collectibleType.localized)을 잡았습니다.")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding()
                }
            }
            Section(header: Text("다음달부터 새로 출현하는 \(collectibleType.localized)").font(.headline).bold()) {
                if self.collectibleType == .fish && !self.viewModel.nextMonthAvailableFishList.isEmpty {
                    ForEach(self.viewModel.nextMonthAvailableFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else if self.collectibleType == .insect && !self.viewModel.nextMonthAvailableInsectList.isEmpty {
                    ForEach(self.viewModel.nextMonthAvailableInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                } else if viewModel.collectibleFilter.isEnableFilter(fromFish: collectibleType == .fish) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                            Text("필터에 맞는 \(collectibleType.localized)가 없습니다.")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding()
                } else {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                            Text("다음달부터 출현하는 \(collectibleType.localized)가 없습니다.")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding()
                }
            }
            Section(header: Text("북마크").font(.headline).bold()) {
                if self.collectibleType == .fish {
                    ForEach(self.viewModel.favoritedFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else {
                    ForEach(self.viewModel.favoritedInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                }
            }
            Section(header: Text("기증됨").font(.headline).bold()) {
                if self.collectibleType == .fish {
                    ForEach(self.viewModel.endowmentedFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else {
                    ForEach(self.viewModel.endowmentedInsectList) { insect in
                        InsectListCellView(insect: insect)
                    }
                }
            }
            Section(header: Text("채집됨").font(.headline).bold()) {
                if self.collectibleType == .fish {
                    ForEach(self.viewModel.gatheredFishList) { fish in
                        FishListCellView(fish: fish)
                    }
                } else {
                    ForEach(self.viewModel.gatheredInsectList) { insect in
                        InsectListCellView(insect: insect)
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
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .font(.caption)
                            .foregroundColor(Color(fish.isFavorite ? .label : .gray) )
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(fish.isGathered ? .label : .gray) )
                            Image(uiImage: UIImage(named: "owl.fill")!.withRenderingMode(.alwaysTemplate))
                                .resizable()
                                .frame(width: 11, height: 11)
                                .colorMultiply(Color(fish.isEndowmented ? .label : .gray) )
                    }
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
                        }.foregroundColor(Color(fish.hourList[safe: DateManager.shared.currentDate.hour] == true ? .label : .red) )
                    }
                    HStack {
                        Image(systemName: "location")
                            .font(.footnote)
                        Text(fish.area?.localized ?? "")
                            .font(.footnote)
                            .bold()
                    }
                }
            }.contextMenu {
                fish.contextMenuContents()
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
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .font(.caption)
                            .foregroundColor(Color(insect.isFavorite ? .label : .gray) )
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(insect.isGathered ? .label : .gray) )
                        Image(uiImage: UIImage(named: "owl.fill")!.withRenderingMode(.alwaysTemplate))
                            .resizable()
                            .frame(width: 11, height: 11)
                            .colorMultiply(Color(insect.isEndowmented ? .label : .gray) )
                    }
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
                        }.foregroundColor(Color(insect.hourList[safe: DateManager.shared.currentDate.hour] == true ? .label : .red) )
                    }
                    HStack {
                        Image(systemName: "location")
                            .font(.footnote)
                        Text(insect.area?.rawValue ?? "")
                            .font(.footnote)
                            .bold()
                    }
                }
            }.contextMenu {
                insect.contextMenuContents()
            }
        }
    }
}

extension Gatherable {
    
    func contextMenuContents() -> some View {
        Group {
            Button(action: {
                self.switchFavorite()
                Refresher.shared.collectibleFlagableRefreshSubject.send(true)
            }) {
                Text("북마크 상태 전환")
                Image(systemName: "bookmark")
            }
            Button(action: {
                self.switchGathering()
                Refresher.shared.collectibleFlagableRefreshSubject.send(true)
            }) {
                Text("채집 상태 전환")
                Image(systemName: "checkmark.circle")
            }
            Button(action: {
                self.switchEndowment()
                Refresher.shared.collectibleFlagableRefreshSubject.send(true)
            }) {
                Text("기부 상태 전환")
                Image("owl")
            }
        }
    }
}
