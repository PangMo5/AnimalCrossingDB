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
    @State var isShowingDatePicker = false
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
                    Button(action: {
                        self.isShowingDatePicker = !self.isShowingDatePicker
                    }) {
                        HStack {
                            Text("시간 설정")
                            Spacer()
                            Text(self.viewModel.currentDate.dateTimeString())
                        }
                    }
                    if self.isShowingDatePicker {
                        Button(action: {
                            self.viewModel.currentDate = Date()
                            DateManager.shared.adjustDate = nil
                            self.isShowingDatePicker = false
                        }) {
                            HStack {
                                Spacer()
                                Text("초기화")
                            }
                        }
                        DatePicker("", selection: $viewModel.currentDate, in: DateManager.shared.initDate...)
                            .labelsHidden()
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
                Section(header: Text("Dev by PangMo5"), footer: Text("App Icon by 화라낙현, Icon by icons8.com")) {
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
                Section(header: Text("DB 정리 by 게밥")) {
                    Button(action: {
                        self.viewModel.openURL(.gebob)
                    }) {
                        Text("Blog")
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
            .onDisappear {
                Refresher.shared.collectibleFlagableRefreshSubject.send(true)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
