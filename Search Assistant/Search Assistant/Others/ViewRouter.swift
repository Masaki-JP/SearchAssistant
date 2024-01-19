import Foundation

/// - Important: スプラッシュスクリーンの実装に`ViewRouter`を使用せず、overlayモディファイアなどを用いての実装を試みたところシステムイメージなどが読み込まれないなどといった不具合が生じたため、スプラッシュスクリーンは`ViewRouter`を使用する。（2024年1月20日）
@MainActor
final class ViewRouter: ObservableObject {
    @Published private(set) var currentView: ViewDestination = .splashScreenView
    static let shared = ViewRouter()
    private init(){}

    enum ViewDestination {
        case splashScreenView, contentView
    }

    func changeView(to selectedView: ViewDestination) {
        self.currentView = selectedView
    }
}
