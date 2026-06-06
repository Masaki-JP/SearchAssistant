import SwiftUI

struct FocusControlSection: View {
    @Binding private(set) var isOn: Bool

    var body: some View {
        Section {
            Toggle(isOn: $isOn) {
                Text("キーボードの自動表示")
            }.tint(.green)
        } header: {
            Text("キーボード")
        } footer: {
            Text("検索画面が表示された時に、検索フォームに自動でフォーカスします。")
        }
    }
}

#Preview {
    List {
        FocusControlSection(isOn: Binding.constant(true))
    }
}
