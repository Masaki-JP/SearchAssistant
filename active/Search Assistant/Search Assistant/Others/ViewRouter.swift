//
//  ViewRouter.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/10.
//

import Foundation

final class ViewRouter: ObservableObject {
    static let shared = ViewRouter()
    private init(){}
    
    enum Selected {
        case splashScreenView
        case contentView
    }
    
    @Published private(set) var selected: Selected = .splashScreenView
    
    func changeView(to selectedView: Selected) {
        self.selected = selectedView
    }
}
