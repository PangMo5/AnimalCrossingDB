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
            VStack(alignment: .leading) {
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
                    Text(viewModel.art.name ?? "")
                        .font(.largeTitle)
                        .bold()
                    Divider()
                    Text(viewModel.art.info ?? "")
                        .font(.headline)
                }.padding()
            }
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
