import SwiftUI

protocol ViewModelForSuggestionList: ObservableObject {
    var suggestions: [String]? { get }
    func search(_ userInput: String, on: SASerchPlatform)
}

struct SuggestionList<ViewModel>: View where ViewModel: ViewModelForSuggestionList {
    @ObservedObject private(set) var vm: ViewModel

    var body: some View {
        switch vm.suggestions {
        case .some(let suggestions):
            List {
                Section {
                    ForEach(suggestions, id: \.self) { suggestion in
                        SuggestionButton(suggestion: suggestion) {
                            vm.search(suggestion, on: .google)
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
    var suggestion: String
    var action: () -> Void

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
        SuggestionList(vm: MockViewModel1())
        // 検索候補を取得できたが、それが空だった場合
        SuggestionList(vm: MockViewModel2())
        // 検索候補の取得に失敗した場合
        SuggestionList(vm: MockViewModel3())
        // 実際のViewModel
        SuggestionList(vm: ViewModel.shared)
    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
}

fileprivate class MockViewModel1: ViewModelForSuggestionList {
    var suggestions: [String]? = [
        "macbook", "macbook air", "macbook air m2", "macbook スクショ", "macbook air m1", "macbook 初期化", "macbook pro m3", "macbook air m3", "macbook 中古", "macbook 学割"
    ]

    func search(_ userInput: String, on: SASerchPlatform) {
        print("Called search function.")
    }
}

fileprivate class MockViewModel2: ViewModelForSuggestionList {
    var suggestions: [String]? = []

    func search(_ userInput: String, on: SASerchPlatform) {
        print("Called search function.")
    }
}

fileprivate class MockViewModel3: ViewModelForSuggestionList {
    var suggestions: [String]? = nil

    func search(_ userInput: String, on: SASerchPlatform) {
        print("Called search function.")
    }
}
