//
//  FishDetailView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct FishDetailView: View {
    
    @ObservedObject var viewModel: FishDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Image(uiImage: viewModel.fish.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Group {
                    HStack {
                        Text("이름")
                        Text(viewModel.fish.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("영어 이름")
                        Text(viewModel.fish.englishName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("가격")
                        Text(viewModel.fish.price?.string ?? "")
                            .font(.title)
                            .bold()
                    }
                }
                Group {
                    Divider()
                    HStack {
                        Text("출현 장소")
                        Text(viewModel.fish.area?.localized ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("출현 시기")
                        Text(viewModel.fish.monthString)
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("출현 시간")
                        Text(viewModel.fish.availableTime ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("크기")
                        Text(viewModel.fish.size?.localized ?? "")
                            .font(.title)
                            .bold()
                    }
                }
            }.padding()
        }
        .navigationBarTitle(viewModel.fish.name ?? "")
        .navigationBarItems(trailing: Button(action: {
            self.viewModel.switchFavorite()
        }) {
            Image(systemName: self.viewModel.isFavorite ? "bookmark.fill" : "bookmark")
        })
    }
}

struct FishDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FishDetailView(viewModel: .init(fish: .sampleFish))
    }
}
