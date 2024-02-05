import SwiftUI

struct SearchButtonSection: View {
    @Binding var isOn: Bool

    var body: some View {
        Section {
            Toggle(isOn: $isOn) {
                Text("左利き用の配置")
            }.tint(.green)
        } header: {
            Text("検索ボタン")
        } footer: {
            Text("検索ボタンを画面左下に配置します。")
        }
    }
}

#Preview {
    List {
        SearchButtonSection(isOn: Binding.constant(true))
    }
}
