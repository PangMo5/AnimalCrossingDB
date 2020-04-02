//
//  SettingView.swift
//  AnimeRadio
//
//  Created by Shirou on 2020/02/02.
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
                            Text("지역")
                            Spacer()
                            Divider()
                            Text(self.viewModel.hemisphere.localized)
                                .font(.callout)
                        }
                    }
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
                Section(header: Text("PangMo5")) {
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
