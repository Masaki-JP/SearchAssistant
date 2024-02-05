import SwiftUI

struct ColorSchemeSection: View {
    @Binding private(set) var selection: String

    var body: some View {
        Section {
            Picker("外観モード", selection: $selection) {
                Text("ライト").tag(ColorSchemeSetting.light.rawValue)
                Text("ダーク").tag(ColorSchemeSetting.dark.rawValue)
                Text("システム").tag(ColorSchemeSetting.system.rawValue)
            }
        } header: {
            Text("外観モード")
        } footer: {
            Text("iPhoneの外観モードと同じものにするにはシステムを選択してください。")
        }
    }
}

#Preview {
    List {
        ColorSchemeSection(selection: Binding.constant(ColorSchemeSetting.system.rawValue))
    }
}
