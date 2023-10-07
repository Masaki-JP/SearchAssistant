//
//  praceAtBottomRight.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import SwiftUI

// コンテントがZStack内にある場合、コンテントを右下に配置する
struct praceAtBottomRightIfInZStack: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
         Spacer()
            HStack {
                Spacer()
                content.padding(.trailing)
            }
        }
    }
}

