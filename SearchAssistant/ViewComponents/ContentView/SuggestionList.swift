import SwiftUI

struct SuggestionList: View {
    let suggestions: [String]
    let action: (String, SearchPlatform) -> Void
    
    var body: some View {
        List {
            Section {
                ForEach(suggestions, id: \.self) { suggestion in
                    rowButton(suggestion: suggestion) {
                        action(suggestion, .google)
                    }
                }
            } header: {
                Text("Suggestions")
                    .textCase(.none)
            }
        }
    }
    
    func rowButton(suggestion: String, action: @escaping () -> Void) -> some View {
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
