//
//  Search_AssistantApp.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI

@main
struct Search_AssistantApp: App {
    @StateObject var viewRouter = ViewRouter.shared
    @StateObject private var vm = ViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            switch viewRouter.selected {
            case .splashScreenView:
                SplashScreenView()
            case .contentView:
                ContentView(vm: vm)
            }
        }
    }
}
