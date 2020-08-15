//
//  SeafoodDetailView.swift
//  AnimalCrossingDB
//
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct SeafoodDetailView: View {
    
    @ObservedObject var viewModel: SeafoodDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Image(uiImage: viewModel.seafood.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Group {
                    HStack {
                        Text("이름")
                        Text(viewModel.seafood.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("영문 이름")
                        Text(viewModel.seafood.englishName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("가격")
                        Text("\(viewModel.seafood.price?.string ?? "")벨")
                            .font(.title)
                            .bold()
                    }
                }
                Group {
                    Divider()
                    HStack {
                        Text("출현 시기")
                        AvailableMonthView(monthList: viewModel.seafood.monthList)
                    }
                    Divider()
                    HStack {
                        Text("출현 시간")
                        Text(viewModel.seafood.availableTime ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("크기")
                        Text(viewModel.seafood.size?.localized ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("속도")
                        Text(viewModel.seafood.speed?.localized ?? "")
                            .font(.title)
                            .bold()
                    }
                }
            }.padding()
        }
        .navigationBarTitle(viewModel.seafood.name ?? "")
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.viewModel.switchEndowment()
                }) {
                    Image(self.viewModel.isEndowmented ? "owl.fill" : "owl")
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                Button(action: {
                    self.viewModel.switchGathering()
                }) {
                    Image(systemName: self.viewModel.isGathered ? "checkmark.circle.fill" : "checkmark.circle")
                }.padding()
                Button(action: {
                    self.viewModel.switchFavorite()
                }) {
                    Image(systemName: self.viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                }
            }
        )
    }
}

struct SeafoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SeafoodDetailView(viewModel: .init(seafood: .sampleSeafood))
    }
}
