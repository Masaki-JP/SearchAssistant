import SwiftUI

struct InlineNavigationTitle: ViewModifier {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    func inlineNavigationTitle(_ title: String) -> some View {
        modifier(InlineNavigationTitle(title))
    }
}
