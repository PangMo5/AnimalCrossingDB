//
//  FossilDetailView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct FossilDetailView: View {
    
    @ObservedObject var viewModel: FossilDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Image(uiImage: viewModel.fossil.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Group {
                    HStack {
                        Text("이름")
                        Text(viewModel.fossil.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("영문 이름")
                        Text(viewModel.fossil.enName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("세트 명")
                        Text(viewModel.fossil.setName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("가격")
                        Text(viewModel.fossil.price ?? "")
                            .font(.title)
                            .bold()
                    }
                }
            }.padding()
        }
        .navigationBarTitle(viewModel.fossil.name ?? "")
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

struct FossilDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FossilDetailView(viewModel: .init(fossil: .sampleFossil))
    }
}
