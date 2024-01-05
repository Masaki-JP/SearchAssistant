import SwiftUI

struct SuggestionList: View {
    @ObservedObject private(set) var vm: ViewModel
    @Binding private(set) var userInput: String

    var body: some View {
        if let suggestions = vm.suggestions {
            List {
                Section {
                    ForEach(suggestions.indices, id: \.self) { i in
                        Button(action: {
                            vm.search(suggestions[i])
                            userInput.removeAll()
                        }, label: {
                            HStack {
                                Text(suggestions[i])
                                    .padding(.leading, 4)
                                Spacer()
                                Text("on Google")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        })
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Suggestions")
                        .textCase(.none)
                }
            }
        } else {
            NoContentsView(
                title: "Sorry! Network Error!",
                description: "検索候補の取得に失敗しました。モバイル通信、Wi-Fi、機内モードなどの設定をご確認ください。",
                imageSystemName: "network.slash"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    SuggestionList(vm: ViewModel.shared, userInput: Binding.constant(""))
}
