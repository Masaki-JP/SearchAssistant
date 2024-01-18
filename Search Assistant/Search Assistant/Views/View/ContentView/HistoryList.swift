import SwiftUI

@MainActor
protocol ViewModelForHistoryList: ObservableObject {
    var historys: [SASerachHistory] { get }
    func search(_ userInput: String, on: SASerchPlatform)
    func getDateString(from: Date) -> String
    func removeHistory(atOffsets: IndexSet)
    var isShowPromptToConfirmDeletionOFAllHistorys: Bool { get set }
}

struct HistoryList<VM>: View where VM: ViewModelForHistoryList {
    @ObservedObject private(set) var vm: VM

    var body: some View {
        if vm.historys.isEmpty == false {
            List {
                Section {
                    ForEach(vm.historys) { history in
                        SearchHistoryButton(
                            history: history,
                            dateString: vm.getDateString(from: history.date),
                            action: {
                                vm.search(history.userInput, on: history.platform)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        vm.removeHistory(atOffsets: indexSet)
                    }
                } header: {
                    Text("Historys")
                        .textCase(.none)
                } footer: {
                    if vm.historys.isEmpty == false {
                        Button("全履歴を削除", role: .destructive) {
                            vm.isShowPromptToConfirmDeletionOFAllHistorys = true
                        }
                        .font(.title3)
                        .disabled(vm.historys.isEmpty)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                    }
                }
            }
        } else {
            NoContentsView(
                title: "I am Search Assistant!",
                description: "Google, Twitter, Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。",
                imageSystemName: "doc.text.magnifyingglass"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SearchHistoryButton: View {
    let history: SASerachHistory
    let dateString: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(history.platform.iconCharacter)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(history.platform.imageColor)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                Text(history.userInput)
                    .padding(.leading, 4)
                Spacer()
                Text(dateString)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        })
        .foregroundStyle(.primary)
    }
}

#Preview {
    TabView {
        // 検索履歴がある場合
        HistoryList(vm: MockViewModel1())
        // 検索履歴がない場合
        HistoryList(vm: MockViewModel2())
        // 実際のContentViewModel
        HistoryList(vm: ContentViewModel.shared)
    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
}

fileprivate class MockViewModel1: ViewModelForHistoryList {
    var historys: [SASerachHistory] = [
        .init(userInput: "iPhone 15 Pro", platform: .google),
        .init(userInput: "iPad Pro", platform: .twitter),
        .init(userInput: "Studio Display", platform: .instagram),
        .init(userInput: "AirPods", platform: .mercari),
        .init(userInput: "iMac", platform: .amazon),
        .init(userInput: "Apple Pencil", platform: .youtube),
        .init(userInput: "Macbook Air", platform: .facebook),
        .init(userInput: "Xcode", platform: .google),
        .init(userInput: "Apple Watch", platform: .twitter),
        .init(userInput: "AirPods", platform: .rakuma),
        .init(userInput: "iPod touch", platform: .instagram),
        .init(userInput: "Apple Vision Pro", platform: .amazon),
        .init(userInput: "Safari", platform: .youtube),
        .init(userInput: "Tim Cook", platform: .facebook),
        .init(userInput: "iPhone SE", platform: .google),
        .init(userInput: "Apple Store", platform: .amazon),
        .init(userInput: "Steve Jobs", platform: .paypayFleaMarket),
        .init(userInput: "Apple Watch Ultra", platform: .google),
        .init(userInput: "iCloud", platform: .amazon),
        .init(userInput: "Apple Music", platform: .google),
    ]

    func search(_ userInput: String, on: SASerchPlatform) {
        print("Called search function.")
    }

    func getDateString(from: Date) -> String {
        return "20xx/xx/xx"
    }

    func removeHistory(atOffsets: IndexSet) {
        print("Called removeHistory function.")
    }

    var isShowPromptToConfirmDeletionOFAllHistorys: Bool = false
}

fileprivate class MockViewModel2: ViewModelForHistoryList {
    var historys: [SASerachHistory] = []

    func search(_ userInput: String, on: SASerchPlatform) {
        print("Called search function.")
    }

    func getDateString(from: Date) -> String {
        return "20xx/xx/xx"
    }

    func removeHistory(atOffsets: IndexSet) {
        print("Called removeHistory function.")
    }

    var isShowPromptToConfirmDeletionOFAllHistorys: Bool = false
}
