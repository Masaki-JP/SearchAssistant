import SwiftUI

struct SuggestionList: View {
    let suggestions: [String]
    let onRowTapped: (String, SearchPlatform) -> Void
    
    var body: some View {
        List {
            Section {
                /// 通常はsuggestionsに重複はなく、 現状では並び替えや削除もないため、idにselfを使用する。
                ForEach(suggestions, id: \.self) { suggestion in
                    suggestionRowButton(suggestion: suggestion) {
                        onRowTapped(suggestion, .google)
                    }
                    .padding(.top, suggestions.first == suggestion ? 4 : 0)
                    .padding(.bottom, suggestions.last == suggestion ? 4 : 0)
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                        return -5
                    })
                    .alignmentGuide(.listRowSeparatorTrailing, computeValue: { viewDementions in
                        return viewDementions.width + 5
                    })
                    .listRowInsets(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
                }
            } header: {
                Text("Suggestions")
                    .textCase(.none)
            }
        }
    }
    
    func suggestionRowButton(suggestion: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .bottom, spacing: .zero) {
                Text(suggestion)
                    .padding(.leading, 4)
                
                Spacer(minLength: 4)
                
                Text("on Google")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }
            .contentShape(.rect)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    SuggestionList(
        suggestions: [
            "macbook", "macbook air", "macbook air m2", "macbook スクショ", "macbook air m1", "macbook 初期化", "macbook pro m3", "macbook air m3", "macbook 中古", "macbook 学割"
        ],
        onRowTapped: { (str, platform) in print(str, platform) }
    )
}
