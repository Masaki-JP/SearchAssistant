//
//  Search_AssistantApp.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI

@main
struct Search_AssistantApp: App {
    @StateObject private var vm = ViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
            /// アプリのカラースキームをダークに設定
            .preferredColorScheme(.dark)
        }
    }
}