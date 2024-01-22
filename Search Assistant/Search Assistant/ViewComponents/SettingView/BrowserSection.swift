import SwiftUI

struct BrowserSection: View {
    @Binding private(set) var isOn: Bool

    var body: some View {
        Section {
            Toggle("アプリ内ブラウザで開く", isOn: $isOn)
        } header: {
            Text("ブラウザ")
        } footer: {
            Text("上記の設定をオフにした場合、検索はSafariで行われます。")
        }
    }
}

#Preview {
    List {
        BrowserSection(isOn: Binding.constant(true))
    }
}
