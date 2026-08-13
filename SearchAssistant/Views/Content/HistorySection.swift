import SwiftUI
import SwiftData
import SearchCore

struct HistorySection: View {
    let histories: [SearchHistory]
    let isBookmarked: (SearchHistory) -> Bool
    let onSearch: (String, SearchPlatform?) -> Void
    let onBookmarkToggled: (SearchHistory) -> Void
    let onDelete: ([SearchHistory]) -> Void
    let onDeleteAllHistories: (() -> Void)?
    
    var body: some View {
        Section {
            ForEach(histories) { history in
                historyRow(history: history) {
                    onSearch(history.userInput, history.platform)
                }
                .padding(.top, histories.first?.id == history.id ? 4 : 0)
                .padding(.bottom, histories.last?.id == history.id ? 4 : 0)
                .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                    return -5
                })
                .alignmentGuide(.listRowSeparatorTrailing, computeValue: { viewDementions in
                    return viewDementions.width + 5
                })
                .listRowInsets(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
            .onDelete { indexSet in
                onDelete(indexSet.map { histories[$0] })
            }
        } header: {
            if let firstHistory = histories.first {
                Text(firstHistory.date.historySectionDisplayString)
                    .fontWeight(.light)
            }
        } footer: {
            if let onDeleteAllHistories {
                Button("全履歴を削除", role: .destructive, action: onDeleteAllHistories)
                    .font(.headline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
        }
    }
    
    func historyRow(history: SearchHistory, action: @escaping () -> Void) -> some View {
        HStack(spacing: 8) {
            Button(action: action) {
                HStack(spacing: nil) {
                    FaviconImage(platform: history.platform)
                    
                    Text(history.userInput)
                        .lineLimit(1)
                        .padding(.leading, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.primary)
            
            Menu {
                Section {
                    Text(history.userInput)
                } header: {
                    Text("検索語句")
                }
                Section {
                    Text(history.platform?.displayName ?? "不明")
                } header: {
                    Text("プラットフォーム")
                }
                Section {
                    Text(history.date.historyDisplayString)
                } header: {
                    Text("日時")
                }
                
                Menu("再検索") {
                    ForEach(SearchPlatform.allCases) { searchPlatform in
                        Button(searchPlatform.displayName) {
                            onSearch(history.userInput, searchPlatform)
                        }
                    }
                }
                
                Divider()
                
                if history.platform != nil {
                    Button(isBookmarked(history) ? "ブックマークを解除" : "ブックマークに登録") {
                        onBookmarkToggled(history)
                    }
                    
                    Divider()
                }
                
                Button("削除", role: .destructive) {
                    onDelete([history])
                }
            } label: {
                Image(systemName: "info.circle")
                    .padding(3)
            }
            .menuOrder(.fixed)
            .foregroundStyle(.tertiary)
            .font(.title2)
        }
    }
}

#Preview {
    @Previewable @State var histories = {
        var histories = Array(SearchHistory.samples[0..<5])
        histories.insert(.init(userInput: "夢なき者に理想なし、理想なき者に計画なし、理想なき者に成功なし。", platform: .google), at: 3)
        histories.insert(.init(userInput: "名古屋駅", platform: .googleMaps), at: 1)
        return histories
    }()
    
    List {
        HistorySection(
            histories: histories,
            isBookmarked: { _ in false },
            onSearch: { print($0, $1 as Any) },
            onBookmarkToggled: { _ in },
            onDelete: { deletedHistories in
                histories.removeAll { deletedHistories.contains($0) }
            },
            onDeleteAllHistories: {
                histories.removeAll()
            }
        )
    }
}
