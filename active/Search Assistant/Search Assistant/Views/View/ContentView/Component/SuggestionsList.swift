import SwiftUI

/*
 SuggestionListの表示条件は、テキストフィールドに何か入力があること
 */

struct SuggestionsList: View {
    @ObservedObject var vm: ViewModel
    @Binding var input: String

    var body: some View {
        if vm.suggestionStore.fetchFailure {
            Text("データ取得に失敗しました。")
                .frame(maxHeight: .infinity)
        } else {
            List {
                Section {
                    ForEach(vm.suggestions.indices, id: \.self) { i in
                        HStack {
                            Button(vm.suggestions[i]) {
                                input.removeAll()
                                vm.Search(vm.suggestions[i])
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
        }
    }
}

#Preview {
    SuggestionsList(vm: ViewModel.shared, input: Binding.constant(""))
}
