import SwiftUI

// コンテントがZStack内にある場合、コンテントを右下に配置する
struct praceAtAppropriatePositionIfInZStack: ViewModifier {
    @ObservedObject var vm: ViewModel
    
    func body(content: Content) -> some View {
        VStack {
         Spacer()
            HStack {
                if !vm.settingLeftSearchButton { Spacer() }
                content
                    .padding(.bottom)
                    .padding(!vm.settingLeftSearchButton ? .trailing : .leading)
                if vm.settingLeftSearchButton { Spacer() }
            }
        }
    }
}
