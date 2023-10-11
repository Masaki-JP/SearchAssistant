//
//  SplashScreen.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2023/01/06.
//

import SwiftUI

struct SplashScreen: View {
    @State var scaleEffect = 0.7
    @State var isActive = true
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.indigo, .blue, .blue, .mint]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            Group {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .foregroundColor(.white)
                    .opacity(0.2)
                
                Text("Search Assistant")
                    .foregroundColor(.white)
                    .font(.custom("AmericanTypewriter-Semibold", size: 40))
            }
            .scaleEffect(scaleEffect)
            
            Button {
                AppState.shared.changeRootView(rootView: .content)
                isActive = false
            } label: {
                Color.clear.ignoresSafeArea()
            }
            
        }
        .onAppear {
            withAnimation {
                scaleEffect = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if isActive {
                    AppState.shared.changeRootView(rootView: .content)
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
