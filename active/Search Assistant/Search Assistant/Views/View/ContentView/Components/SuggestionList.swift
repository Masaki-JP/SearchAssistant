import SwiftUI

struct SuggestionList: View {
    @ObservedObject private(set) var vm: ViewModel
    @Binding private(set) var userInput: String

    var body: some View {
        if let suggestions = vm.suggestions {
            List {
                Section {
                    ForEach(suggestions.indices, id: \.self) { i in
                        HStack {
                            Button(suggestions[i]) {
                                userInput.removeAll()
                                vm.search(suggestions[i])
                            }
                            .font(.body)
                            .foregroundStyle(.primary)
                            .padding(.leading, 4)
                            Spacer()
                            Text("on Google")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 4)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                } header: {
                    Text("Suggestions")
                        .textCase(.none)
                }
            }
        } else {
            Text("データ取得に失敗しました。")
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SuggestionList(vm: ViewModel.shared, userInput: Binding.constant(""))
}
