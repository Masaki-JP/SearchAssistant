//
//  Class_AppState.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2023/01/06.
//

import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    private init(){}
    
    enum RootViews {
        case splash
        case content
    }
    
    @Published private(set) var rootView: RootViews = .splash
    
    func changeRootView(rootView: RootViews) {
            self.rootView = rootView
    }
}

