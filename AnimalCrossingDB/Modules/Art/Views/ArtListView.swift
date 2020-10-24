//
//  ArtListView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct ArtListView: View {
    
    @State private var isModalSettingView = false
    @State private var isModalFilterView = false
    
    @ObservedObject var viewModel: ArtListViewModel
    
    var layout: ASCollectionLayout<Int>
    {
        ASCollectionLayout(createCustomLayout: ASWaterfallLayout.init)
        { layout in
            layout.numberOfColumns = .fixed(2)
        }
    }

    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: self.$viewModel.searchText)
                ASCollectionView(data: viewModel.artList) { art, _ in
                    ArtCellView(art: art)
                }.layout(layout)
                .customDelegate(WaterfallScreenLayoutDelegate.init)
                .resignKeyboardOnDragGesture()
                .animation(.default)
                .padding([.leading, .trailing])
            }
            .navigationBarTitle("미술품")
            .navigationBarItems(leading:
                Button(action: {
                    self.isModalSettingView = true
                }) {
                    Image(systemName: "gear")
                }.sheet(isPresented: self.$isModalSettingView) {
                    SettingView()
            }, trailing: Button(action: {
                self.isModalFilterView = true
                UIApplication.shared.endEditing(true)
            }) {
                if self.viewModel.artFilter.isEnableFilter() {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                } else {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }.sheet(isPresented: self.$isModalFilterView) {
                ArtFilterView(viewModel: .init(filter: self.viewModel.artFilter))
            })
        }
    }
}

struct ArtCellView: View {
    
    var art: Art
    
    var body: some View {
        NavigationLink(destination: ArtDetailView(viewModel: .init(art: art))) {
            ZStack(alignment: .leading) {
                if art.curioImage != nil {
                    Image(uiImage: art.curioImage!)
                        .resizable()
                        .scaledToFit()
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .fixedSize(horizontal: false, vertical: true)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .font(.caption)
                            .foregroundColor(Color(art.isFavorite ? .label : .gray) )
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(art.isGathered ? .label : .gray) )
                        Image(uiImage: UIImage(named: "owl.fill")!.withRenderingMode(.alwaysTemplate))
                            .resizable()
                            .frame(width: 11, height: 11)
                            .colorMultiply(Color(art.isEndowmented ? .label : .gray) )
                    }
                    .padding(4)
                    .background(Color.init(white: 0, opacity: 0.16))
                    .cornerRadius(4)
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(art.name ?? "")
                            .font(.headline)
                            .padding([.leading, .trailing], 6)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("(\(art.realName ?? ""))")
                            .font(.footnote)
                            .padding([.leading, .trailing], 6)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("- \(art.artist ?? "")")
                            .font(.footnote)
                            .padding([.leading, .trailing], 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).background(Color.init(white: 0, opacity: 0.16))
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(4)
            .contextMenu {
                art.contextMenuContents()
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ArtListView_Previews: PreviewProvider {
    static var previews: some View {
        ArtListView(viewModel: .init())
    }
}

class WaterfallScreenLayoutDelegate: ASCollectionViewDelegate, ASWaterfallLayoutDelegate
{
    func heightForHeader(sectionIndex: Int) -> CGFloat? { 0 }

    func heightForCell(at indexPath: IndexPath, context: ASWaterfallLayout.CellLayoutContext) -> CGFloat
    {
        guard let art: Art = getDataForItem(at: indexPath),
              let width = art.curioImage?.size.width,
              let height = art.curioImage?.size.height else { return 100 }
        return context.width / (width / height)
    }
}
