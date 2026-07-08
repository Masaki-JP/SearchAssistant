import SwiftUI
import SearchCore

struct SuggestionList: View {
    let suggestions: [String]
    let onSearch: (String, SearchPlatform) -> Void
    let defaultPlatform: SearchPlatform = .google
    
    var body: some View {
        List {
            Section {
                /// 通常はsuggestionsに重複はなく、 現状では並び替えや削除もないため、idにselfを使用する。
                ForEach(suggestions, id: \.self) { suggestion in
                    suggestionRow(suggestion: suggestion) {
                        onSearch(suggestion, defaultPlatform)
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
    
    func suggestionRow(suggestion: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 8) {
            Button {
                action()
            } label: {
                Text(suggestion)
                    .padding(.leading, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            
            Menu("Menu", systemImage: "ellipsis.circle") {
                Section {
                    ForEach(SearchPlatform.allCases) { searchPlatform in
                        Button(searchPlatform.displayName) {
                            onSearch(suggestion, searchPlatform)
                        }
                    }
                } header: {
                    Text("検索")
                }
            }
            .menuOrder(.fixed)
            .labelStyle(.iconOnly)
            .foregroundStyle(.secondary)
            .font(.title2)
            .fontWeight(.light)
        }
    }
}

#Preview {
    SuggestionList(
        suggestions: [
            "macbook", "macbook air", "macbook air m2", "macbook スクショ", "macbook air m1", "macbook 初期化", "macbook pro m3", "macbook air m3", "macbook 中古", "macbook 学割"
        ],
        onSearch: { (str, platform) in print(str, platform) }
    )
}
