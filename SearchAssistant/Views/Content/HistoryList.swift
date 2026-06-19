import SwiftUI
import SwiftData
import SearchCore

struct HistoryList: View {
    let histories: [SearchHistory]
    let onRowTapped: (String, SearchPlatform?) -> Void
    let onDelete: (IndexSet) -> Void
    @Binding var isPresentedDeleteAllHistoriesAlert: Bool
    
    var body: some View {
        List {
            Section {
                ForEach(histories) { history in
                    historyRowButton(history: history) {
                        onRowTapped(history.userInput, history.platform)
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
                    onDelete(indexSet)
                }
            } header: {
                Text("Histories")
                    .textCase(.none)
            } footer: {
                Button("全履歴を削除", role: .destructive) {
                    isPresentedDeleteAllHistoriesAlert = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            }
        }
    }
    
    func historyRowButton(history: SearchHistory, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            ViewThatFits(in: .horizontal) {
                singleLineLabel(history: history)
                multiLineLabel(history: history)
            }
            .contentShape(.rect)
        })
        .buttonStyle(.plain)
    }
    
    func singleLineLabel(history: SearchHistory) -> some View {
        HStack(spacing: nil) {
            faviconImage(history.platform)
            
            Text(history.userInput)
                .padding(.leading, 4)
            
            Spacer()
            
            Text(history.date.string())
                .foregroundStyle(.secondary)
                .font(.caption2)
                .padding(.vertical, 4)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    func multiLineLabel(history: SearchHistory) -> some View {
        HStack(alignment: .top, spacing: nil) {
            faviconImage(history.platform)
            
            VStack(spacing: 4) {
                Text(history.userInput)
                    .padding(.leading, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(history.date.string())
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    @ViewBuilder
    func faviconImage(_ platform: SearchPlatform?) -> some View {
        Group {
            if let platform, let uiImage = UIImage(resourceName: platform.faviconResourceName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Text(platform?.iconCharacter ?? "?")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.secondary)
            }
        }
        .frame(width: 28, height: 28)
    }
}

fileprivate extension UIImage {
    convenience init?(resourceName: String) {
        if UIImage(named: resourceName) != nil {
            self.init(named: resourceName)
            return
        }
        
        guard let bundleImageURL = Bundle.main.url(
            forResource: resourceName,
            withExtension: "png"
        ) else {
            return nil
        }
        
        self.init(contentsOfFile: bundleImageURL.path)
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
    var histories = SearchHistory.samples
    let userInput = "夢なき者に理想なし、理想なき者に計画なし、計画なき者に成功なし。"
    histories.insert(.init(userInput: userInput, platform: .google), at: 3)
    
    return HistoryList(
        histories: histories,
        onRowTapped: { userInput, platform in
            print(userInput, platform as Any)
        },
        onDelete: { (_) -> Void in },
        isPresentedDeleteAllHistoriesAlert: Binding.constant(false)
    )
}
