import SwiftUI

struct HistoryList: View {
    let historys: [SearchHistory]
    let searchAction: @MainActor (String, SearchPlatform) -> Void
    let removeHistoryAction: @MainActor (IndexSet) -> Void
    @Binding private(set) var isShowPromptToConfirmDeletionOfAllHistorys: Bool
    
    var body: some View {
        if historys.isEmpty == false {
            List {
                Section {
                    ForEach(historys) { history in
                        SearchHistoryButton(
                            history: history,
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
                description: "Google, Twitter(X), Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。",
                imageSystemName: "doc.text.magnifyingglass"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SearchHistoryButton: View {
    let history: SearchHistory
    let action: @MainActor () -> Void
    
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
                Text(history.date.string())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        })
        .foregroundStyle(.primary)
    }
}

fileprivate extension Date {
    static let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        return dateFormatter}()
    
    func string() -> String {
        Self.dateFormatter.string(from: self)
    }
}

#Preview {
    TabView {
        // 検索履歴がある場合
        HistoryList(
            historys: SearchHistory.samples,
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
