import SwiftUI

struct FocusTextFieldButton: View {
    let diameter: CGFloat = 65
    let action: () -> Void
    
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
    FocusTextFieldButton(action: {})
}
