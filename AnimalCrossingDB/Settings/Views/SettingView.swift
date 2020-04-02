//
//  SettingViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI
import UIKit
import MessageUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SettingViewModel()
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("채집보벳따우")) {
                    Button(action: {
                        self.viewModel.switchHemisphere()
                    }) {
                        HStack {
                            Text("위치")
                            Spacer()
                            Divider()
                            Text(self.viewModel.hemisphere.localized)
                                .font(.callout)
                        }
                    }
//                    Toggle(isOn: $viewModel.enabledBookmarkPush) {
//                        VStack(alignment: .leading) {
//                            Text("채집물 푸시 알림")
//                            Text("채집물을 잡을 수 있는 시간이 되었을때 관련 정보 푸시 알림을 받습니다.")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
                }
                Section(header: Text("기타")) {
                    Button(action: {
                        self.isShowingMailView = true
                    }) {
                        Text("피드백 보내기")
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }
                Section(header: Text("Dev by PangMo5"),footer: Text("App Icon by 화라낙현")) {
                    Button(action: {
                        self.viewModel.openURL(.blog)
                    }) {
                        Text("blog.PangMo5.dev")
                    }
                    Button(action: {
                        self.viewModel.openURL(.github)
                    }) {
                        Text("Github")
                    }
                }
            }.listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("설정"))
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
