//
//  ArtFilterView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct ArtFilterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ArtFilterViewModel
    
    var body: some View {
        NavigationView {
            List {
                stateSection
                Section {
                    Button(action: {
                        self.viewModel.filter = ArtFilter()
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
                    Refresher.shared.artFilterRefreshSubject.send(self.viewModel.filter)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("적용")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ArtFilterView {
    
    var stateSection: some View {
        Section(header: Text("상태")) {
            Toggle(isOn: $viewModel.filter.onlyFavorite) {
                Text("북마크한 미술품만")
            }
            Toggle(isOn: $viewModel.filter.onlyGathered) {
                Text("획득한 미술품만")
            }
            Toggle(isOn: $viewModel.filter.onlyEndowmented) {
                Text("기증한 미술품만")
            }
            Toggle(isOn: $viewModel.filter.onlyNeedGathered) {
                Text("획득 못한 미술품만")
            }
        }
    }
}

struct ArtFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ArtFilterView(viewModel: .init(filter: .init()))
    }
}
