import SwiftUI

struct NoContentView: View {
    let title: String
    let imageSystemName: String
    let descriptionStr: String?
    let descriptionText: Text?
    
    init(title: String, imageSystemName: String, description: String?) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.descriptionStr = description
        self.descriptionText = nil
    }
    init(title: String, imageSystemName: String, description: Text?) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.descriptionStr = nil
        self.descriptionText = description
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundStyle(.secondary)
            
            Text(title)
                .fontWeight(.bold)
                .font(.title2)
            
            Group {
                if let descriptionText {
                    descriptionText
                } else if let descriptionStr {
                    Text(descriptionStr)
                }
            }
            .multilineTextAlignment(.leading)
            .foregroundStyle(.secondary)
            .font(.footnote)

        }
        .frame(width: 350)
    }
}

extension NoContentView {
    static let searchHistory = NoContentView(
        title: "検索を始めましょう",
        imageSystemName: "doc.text.magnifyingglass",
        description: "Google, Twitter(X), Instagram, Amazon, YouTube等の\n検索をこのアプリひとつで行うことができます。",
    )

    static let searchSuggestion = NoContentView(
        title: "候補が見つかりません",
        imageSystemName: "magnifyingglass",
        description: "入力したキーワードでそのまま検索できます。",
    )

    static let searchSuggestionNetworkError = NoContentView(
        title: "通信エラーが発生しました",
        imageSystemName: "network.slash",
        description: "入力内容に基づく検索候補の取得に失敗しました。モバイル通信、Wi-Fi、機内モード等の設定をご確認ください。",
    )
}

#Preview {
    TabView {
        Tab { NoContentView.searchHistory }
        Tab { NoContentView.searchSuggestion }
        Tab { NoContentView.searchSuggestionNetworkError }
    }
    .tabViewStyle(.page)
}
