//
//  SplashView.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var viewModel = SplashViewModel()
    
    @State var isAnimating = true
    
    var body: some View {
        VStack {
            if viewModel.response == nil {
                Text("데이터를 읽는 중 입니다.")
                ActivityIndicator(isAnimating: $isAnimating, style: .large)
            } else {
                MainTabView()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
