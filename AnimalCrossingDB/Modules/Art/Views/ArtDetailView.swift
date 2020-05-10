//
//  ArtDetailView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct ArtDetailView: View {
    
    @ObservedObject var viewModel: ArtDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if viewModel.art.curioImage != nil {
                        Image(uiImage: viewModel.art.curioImage!)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    ForEach(viewModel.art.fakeImages) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Group {
                    HStack {
                        Text("이름")
                        Text(viewModel.art.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("실제 이름")
                        Text(viewModel.art.realName ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("작가")
                        Text(viewModel.art.artist ?? "")
                            .font(.title)
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("정보")
                        VStack {
                            Text(viewModel.art.info ?? "")
                                .font(.headline)
                                .bold()
                            if viewModel.art.advice != nil {
                                Text(viewModel.art.advice ?? "")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                    }
                }
            }.padding()
        }
        .navigationBarTitle(viewModel.art.name ?? "")
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

struct ArtDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtDetailView(viewModel: .init(art: .sampleArt))
    }
}
