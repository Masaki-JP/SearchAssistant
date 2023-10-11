//
//  Search_AssistantApp.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2022/12/01.
//

import SwiftUI

@main
struct Search_AssistantApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            switch appState.rootView {
            case .splash:
                SplashScreen()
            case .content:
                ContentView()
            }
        }
    }
}


