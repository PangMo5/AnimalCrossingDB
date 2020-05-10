//
//  FossilFilterView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct FossilFilterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FossilFilterViewModel
    
    var body: some View {
        NavigationView {
            List {
                stateSection
                Section {
                    Button(action: {
                        self.viewModel.filter = FossilFilter()
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
                    Refresher.shared.fossilFilterRefreshSubject.send(self.viewModel.filter)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("적용")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension FossilFilterView {
    
    var stateSection: some View {
        Section(header: Text("상태")) {
            Toggle(isOn: $viewModel.filter.onlyFavorite) {
                Text("북마크한 화석만")
            }
            Toggle(isOn: $viewModel.filter.onlyGathered) {
                Text("획득한 화석만")
            }
            Toggle(isOn: $viewModel.filter.onlyEndowmented) {
                Text("기증한 화석만")
            }
            Toggle(isOn: $viewModel.filter.onlyNeedGathered) {
                Text("획득 못한 화석만")
            }
        }
    }
}

struct FossilFilterView_Previews: PreviewProvider {
    static var previews: some View {
        FossilFilterView(viewModel: .init(filter: .init()))
    }
}
