import SwiftUI

struct HistoryList: View {
    let historys: [SearchHistory]
    let searchAction: (String, SearchPlatform) -> Void
    let removeHistoryAction: (IndexSet) -> Void
    @Binding var isPresentedDeleteAllHistoriesAlert: Bool
    
    var body: some View {
        List {
            Section {
                ForEach(historys) { history in
                    buttonRow(history: history) {
                        searchAction(history.userInput, history.platform)
                    }
                }
                .onDelete { indexSet in
                    removeHistoryAction(indexSet)
                }
            } header: {
                Text("Historys")
                    .textCase(.none)
            } footer: {
                Button("全履歴を削除", role: .destructive) {
                    isPresentedDeleteAllHistoriesAlert = true
                }
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            }
        }
    }
    
    func buttonRow(history: SearchHistory, action: @escaping () -> Void) -> some View {
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
        .buttonStyle(.plain)
    }
}

fileprivate extension Date {
    static let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        return dateFormatter
    }()
    
    func string() -> String {
        Self.dateFormatter.string(from: self)
    }
}

#Preview {
    HistoryList(
        historys: SearchHistory.samples,
        searchAction: { userInput ,platform in
            print(userInput, platform)
        },
        removeHistoryAction: { (_) -> Void in },
        isPresentedDeleteAllHistoriesAlert: Binding.constant(false)
    )
}
