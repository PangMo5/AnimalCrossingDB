//
//  InsectListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct InsectListView: View {
    
    @ObservedObject var viewModel = InsectListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    Section(header: Text("채집 가능")) {
                        ForEach(self.viewModel.availableInsectList) {
                            InsectListCellView(insect: $0)
                        }
                    }
                    Section(header: Text("채집 불가능")) {
                        ForEach(self.viewModel.disavailableInsectList) {
                            InsectListCellView(insect: $0)
                        }
                    }
                }.listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .resignKeyboardOnDragGesture()
            }
            .navigationBarTitle("곤충")
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
        HStack {
//            FBURLImage(url: "fish/\(insect.id ?? 0).png")
//                .frame(width: 64, height: 64)
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
