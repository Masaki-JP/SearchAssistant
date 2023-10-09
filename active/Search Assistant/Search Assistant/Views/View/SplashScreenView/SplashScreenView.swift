//
//  SplashScreenView.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/09.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Group {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .opacity(0.2)
                
                Text("Search Assistant")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
