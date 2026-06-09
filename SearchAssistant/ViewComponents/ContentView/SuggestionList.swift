import SwiftUI

struct SuggestionList: View {
    let suggestions: [String]
    let action: @MainActor (String, SearchPlatform) -> Void
    
    var body: some View {
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
    SuggestionList(
        suggestions: [
            "macbook", "macbook air", "macbook air m2", "macbook スクショ", "macbook air m1", "macbook 初期化", "macbook pro m3", "macbook air m3", "macbook 中古", "macbook 学割"
        ],
        action: { (str, platform) in print(str, platform) }
    )
}
