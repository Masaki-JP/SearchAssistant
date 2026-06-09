import SwiftUI

struct NoContentView: View {
    let title: String
    let description: String?
    let imageSystemName: String
    
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
            
            if let description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        }
        .frame(width: 350)
    }
}

extension NoContentView {
    static let searchHistory = NoContentView(
        title: "I am Search Assistant !",
        description: "Google, Twitter(X), Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。",
        imageSystemName: "doc.text.magnifyingglass"
    )

    static let searchSuggestion = NoContentView(
        title: "候補が見つかりません",
        description: "入力したキーワードでそのまま検索できます。",
        imageSystemName: "magnifyingglass"
    )

    static let searchSuggestionNetworkError = NoContentView(
        title: "Sorry! Network Error!",
        description: "入力内容に基づく検索候補の取得に失敗しました。モバイル通信、Wi-Fi、機内モードなどの設定をご確認ください。",
        imageSystemName: "network.slash"
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
