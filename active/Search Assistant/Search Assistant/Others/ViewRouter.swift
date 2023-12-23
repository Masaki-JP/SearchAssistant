import Foundation

final class ViewRouter: ObservableObject {
    @Published private(set) var selected: Selected = .splashScreenView
    static let shared = ViewRouter()
    private init(){}

    enum Selected {
        case splashScreenView
        case contentView
    }

    func changeView(to selectedView: Selected) {
        self.selected = selectedView
    }
}
