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
    @State private var showingFilterSheet = false
    @State private var showingFishSizeSheet = false
    @State private var showingAreaSheet = false
    
    var body: some View {
        NavigationView {
            List {
                stateSection
                collectionSection
                dateSection
                Section {
                    Button(action: {
                        self.viewModel.filter = CollectibleFilter()
                    }) {
                        Text("초기화")
                            .foregroundColor(.red)
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
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("적용")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension CollectibleFilterView {
    
    var stateSection: some View {
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
            Toggle(isOn: $viewModel.filter.onlyNeedGathered) {
                Text("채집 못한 채집물만")
            }
        }
    }
    
    var collectionSection: some View {
        Section(header: Text("특성")) {
            if viewModel.fromFish {
                HStack {
                    Text("크기")
                    Spacer()
                    if viewModel.filter.fishSize == nil {
                        Text("전체")
                    } else {
                        Text(viewModel.filter.fishSize?.localized ?? "")
                    }
                }.onTapGesture {
                    self.showingFishSizeSheet = true
                }.actionSheet(isPresented: self.$showingFishSizeSheet) {
                    var buttons = [
                        ActionSheet.Button.default(Text("전체")) {
                            self.viewModel.filter.fishSize = nil
                        }
                    ]
                    buttons.append(contentsOf: Fish.Size.allCases.map { size in ActionSheet.Button.default(Text(size.localized)) {
                        self.viewModel.filter.fishSize = size
                        }
                    })
                    buttons.append(.cancel())
                    return ActionSheet(title: Text("필러링 할 크기를 선택해주세요."), buttons: buttons)
                }
            }
            HStack {
                Text("출현 장소")
                Spacer()
                if viewModel.fromFish {
                    if viewModel.filter.fishArea == nil {
                        Text("전체")
                    } else {
                        Text(viewModel.filter.fishArea?.localized ?? "")
                    }
                } else {
                    if viewModel.filter.insectArea == nil {
                        Text("전체")
                    } else {
                        Text(viewModel.filter.insectArea?.rawValue ?? "")
                    }
                }
            }.onTapGesture {
                self.showingAreaSheet = true
            }.actionSheet(isPresented: self.$showingAreaSheet) {
                var buttons = [
                    ActionSheet.Button.default(Text("전체")) {
                        if self.viewModel.fromFish {
                            self.viewModel.filter.fishArea = nil
                        } else {
                            self.viewModel.filter.insectArea = nil
                        }
                    }
                ]
                if self.viewModel.fromFish {
                    buttons.append(contentsOf: Fish.Area.allCases.map { area in ActionSheet.Button.default(Text(area.localized)) {
                        self.viewModel.filter.fishArea = area
                        }
                    })
                } else {
                    buttons.append(contentsOf: Insect.Area.allCases.map { area in ActionSheet.Button.default(Text(area.rawValue)) {
                        self.viewModel.filter.insectArea = area
                        }
                    })
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("필러링 할 출현 장소를 선택해주세요."), buttons: buttons)
            }
        }
    }
    
    var dateSection: some View {
        Section(header: Text("시간")) {
            HStack {
                Text("출현 시기")
                Spacer()
                if viewModel.filter.month == nil {
                    Text("전체")
                } else {
                    Text("\(viewModel.filter.month ?? 0)월")
                }
            }.onTapGesture {
                self.showingFilterSheet = true
            }.actionSheet(isPresented: self.$showingFilterSheet) {
                var buttons = [
                    ActionSheet.Button.default(Text("전체")) {
                        self.viewModel.filter.month = nil
                    }
                ]
                buttons.append(contentsOf: (1...12).compactMap(Int.init).map { month in ActionSheet.Button.default(Text("\(month)월")) {
                    self.viewModel.filter.month = month
                    }
                })
                buttons.append(.cancel())
                return ActionSheet(title: Text("필러링 할 시기를 선택해주세요."), buttons: buttons)
            }
        }
    }
}

struct CollectibleFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CollectibleFilterView(viewModel: .init(fromFish: true, filter: .init()))
    }
}
