import SwiftUI

struct SearchButton: View {
    private let diameter: CGFloat
    private let action: () -> Void
    
    init(_ diameter: CGFloat = 65, action: @escaping () -> Void) {
        self.diameter = diameter
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .frame(width: diameter, height: diameter)
                .background(.white)
                .clipShape(Circle().scale(0.95))
        }
    }
}

#Preview {
    SearchButton(action: {})
}
