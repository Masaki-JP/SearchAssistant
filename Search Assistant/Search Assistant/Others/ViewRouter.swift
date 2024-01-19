import Foundation

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
