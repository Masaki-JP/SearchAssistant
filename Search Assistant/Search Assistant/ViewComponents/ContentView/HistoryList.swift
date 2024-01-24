import SwiftUI

struct HistoryList: View {
    let historys: [ContentViewModel.HistoryInfo]
    let searchAction: @MainActor (String, SASerchPlatform) -> Void
    let removeHistoryAction: @MainActor (IndexSet) -> Void
    @Binding var isShowPromptToConfirmDeletionOfAllHistorys: Bool

    var body: some View {
        if historys.isEmpty == false {
            List {
                Section {
                    ForEach(historys) { history in
                        SearchHistoryButton(
                            history: history,
                            dateString: history.dateString,
                            action: {
                                searchAction(history.userInput, history.platform)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        removeHistoryAction(indexSet)
                    }
                } header: {
                    Text("Historys")
                        .textCase(.none)
                } footer: {
                    if historys.isEmpty == false {
                        Button("全履歴を削除", role: .destructive) {
                            isShowPromptToConfirmDeletionOfAllHistorys = true
                        }
                        .font(.title3)
                        .disabled(historys.isEmpty)
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
    private let history: ContentViewModel.HistoryInfo
    private let dateString: String
    private let action: @MainActor () -> Void

    init(history: ContentViewModel.HistoryInfo, dateString: String, action: @escaping @MainActor () -> Void) {
        self.history = history
        self.dateString = dateString
        self.action = action
    }

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
        HistoryList(
            historys: [
                .init(userInput: "iPhone 15 Pro", platform: .google, dateString: "2022/01/01", id: UUID()),
                .init(userInput: "iPad Pro", platform: .twitter, dateString: "2022/02/01", id: UUID()),
                .init(userInput: "Studio Display", platform: .instagram, dateString: "2022/03/01", id: UUID()),
                .init(userInput: "AirPods", platform: .mercari, dateString: "2022/04/01", id: UUID()),
                .init(userInput: "iMac", platform: .amazon, dateString: "2022/05/01", id: UUID()),
                .init(userInput: "Apple Pencil", platform: .youtube, dateString: "2022/06/01", id: UUID()),
                .init(userInput: "Macbook Air", platform: .facebook, dateString: "2022/07/01", id: UUID()),
                .init(userInput: "Xcode", platform: .google, dateString: "2022/08/01", id: UUID()),
                .init(userInput: "Apple Watch", platform: .twitter, dateString: "2022/09/01", id: UUID()),
                .init(userInput: "AirPods", platform: .rakuma, dateString: "2022/10/01", id: UUID()),
                .init(userInput: "iPod touch", platform: .instagram, dateString: "2022/11/01", id: UUID()),
                .init(userInput: "Apple Vision Pro", platform: .amazon, dateString: "2022/12/01", id: UUID()),
                .init(userInput: "Safari", platform: .youtube, dateString: "2023/01/01", id: UUID()),
                .init(userInput: "Tim Cook", platform: .facebook, dateString: "2023/02/01", id: UUID()),
                .init(userInput: "iPhone SE", platform: .google, dateString: "2023/03/01", id: UUID()),
                .init(userInput: "Apple Store", platform: .amazon, dateString: "2023/04/01", id: UUID()),
                .init(userInput: "Steve Jobs", platform: .paypayFleaMarket, dateString: "2023/05/01", id: UUID()),
                .init(userInput: "Apple Watch Ultra", platform: .google, dateString: "2023/06/01", id: UUID()),
                .init(userInput: "iCloud", platform: .amazon, dateString: "2023/07/01", id: UUID()),
                .init(userInput: "Apple Music", platform: .google, dateString: "2023/08/01", id: UUID()),
            ],
            searchAction: { userInput ,platform in
                print(userInput, platform)
            },
            removeHistoryAction: { (_) -> Void in },
            isShowPromptToConfirmDeletionOfAllHistorys: Binding.constant(false)
        )

        // 検索履歴がない場合
        HistoryList(
            historys: [],
            searchAction: { (_ ,_) -> Void in },
            removeHistoryAction: { (_) -> Void in },
            isShowPromptToConfirmDeletionOfAllHistorys: Binding.constant(false)
        )
    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
}
