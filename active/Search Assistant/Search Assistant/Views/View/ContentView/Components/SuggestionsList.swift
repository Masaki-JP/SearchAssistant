import SwiftUI

/*
 SuggestionListの表示条件は、テキストフィールドに何か入力があること
 */

struct SuggestionsList: View {
    @ObservedObject var vm: ViewModel
    @Binding var userInput: String

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
                }
            }
        } else {
            Text("データ取得に失敗しました。")
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SuggestionsList(vm: ViewModel.shared, userInput: Binding.constant(""))
}
