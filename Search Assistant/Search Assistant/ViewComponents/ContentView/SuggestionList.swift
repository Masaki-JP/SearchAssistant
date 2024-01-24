import SwiftUI

struct SuggestionList: View {
    private let suggestions: [String]?
    private let action: @MainActor (String, SerchPlatform) -> Void

    init(
        suggestions: [String]?,
        action: @escaping @MainActor (String, SerchPlatform) -> Void
    ) {
        self.suggestions = suggestions
        self.action = action
    }

    var body: some View {
        switch suggestions {
        case .some(let suggestions):
            List {
                Section {
                    ForEach(suggestions.indices, id: \.self) { i in
                        SuggestionButton(suggestion: suggestions[i]) {
                            action(suggestions[i], .google)
                        }
                    }
                } header: {
                    Text("Suggestions")
                        .textCase(.none)
                }
            }
        case .none:
            NoContentsView(
                title: "Sorry! Network Error!",
                description: "入力内容に基づく検索候補の取得に失敗しました。モバイル通信、Wi-Fi、機内モードなどの設定をご確認ください。",
                imageSystemName: "network.slash"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

fileprivate struct SuggestionButton: View {
    let suggestion: String
    let action: @MainActor () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .bottom) {
                Text(suggestion)
                    .padding(.leading, 4)
                Spacer()
                Text("on Google")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }
        })
        .foregroundStyle(.primary)
    }
}

#Preview {
    TabView {
        // 正常に検索候補を取得できた場合
        SuggestionList(
            suggestions: [
                "macbook", "macbook air", "macbook air m2", "macbook スクショ", "macbook air m1", "macbook 初期化", "macbook pro m3", "macbook air m3", "macbook 中古", "macbook 学割"
            ],
            action: { (str, platform) in print(str, platform) }
        )
        // 検索候補を取得できたが、それが空だった場合
        SuggestionList(
            suggestions: [],
            action: { (_, _) in }
        )
        // 検索候補の取得に失敗した場合
        SuggestionList(
            suggestions: nil,
            action: { (_, _) in }
        )

    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
}
