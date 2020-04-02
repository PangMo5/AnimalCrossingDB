//
//  InsectDetailView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct InsectDetailView: View {
    
    @ObservedObject var viewModel: InsectDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Image(uiImage: viewModel.insect.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Divider()
                Group {
                    HStack {
                        Text("이름")
                        Text(viewModel.insect.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("영어 이름")
                        Text(viewModel.insect.englishName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("가격")
                        Text(viewModel.insect.price?.string ?? "")
                            .font(.title)
                            .bold()
                    }
                }
                Group {
                    Divider()
                    HStack {
                        Text("출현 장소")
                        Text(viewModel.insect.area?.rawValue ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("출현 시기")
                        Text(viewModel.insect.monthString)
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("출현 시간")
                        Text(viewModel.insect.availableTime ?? "")
                            .font(.title)
                            .bold()
                    }
                }
            }.padding()
        }
        .navigationBarTitle(viewModel.insect.name ?? "")
        .navigationBarItems(trailing: Button(action: {
            self.viewModel.switchFavorite()
        }) {
            Image(systemName: self.viewModel.isFavorite ? "bookmark.fill" : "bookmark")
        })
    }
}

struct InsectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InsectDetailView(viewModel: .init(insect: .sampleInsect))
    }
}
