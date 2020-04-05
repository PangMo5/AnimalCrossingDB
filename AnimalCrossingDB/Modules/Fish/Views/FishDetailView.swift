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
                        Text("\(viewModel.fish.price?.string ?? "")벨")
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
                        AvailableMonthView(monthList: viewModel.fish.monthList)
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

struct FishDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FishDetailView(viewModel: .init(fish: .sampleFish))
    }
}

struct AvailableMonthView: View {
    
    var monthList: [Bool]
    
    var body: some View {
        HStack {
            VStack {
                Text("1월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[0] ? .label : .gray ))
                Text("5월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[4] ? .label : .gray ))
                Text("9월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[8] ? .label : .gray ))
            }
            VStack {
                Text("2월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[1] ? .label : .gray ))
                Text("6월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[5] ? .label : .gray ))
                Text("10월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[9] ? .label : .gray ))
            }
            VStack {
                Text("3월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[2] ? .label : .gray ))
                Text("7월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[6] ? .label : .gray ))
                Text("11월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[10] ? .label : .gray ))
            }
            VStack {
                Text("4월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[3] ? .label : .gray ))
                Text("8월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[7] ? .label : .gray ))
                Text("12월")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(monthList[11] ? .label : .gray ))
            }
        }
    }
}
