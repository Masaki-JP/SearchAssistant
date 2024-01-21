import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    private let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {}
}

#Preview {
    SafariView(URL(string: "https://apple.com")!)
}
