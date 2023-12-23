import SwiftUI

struct SplashScreenView: View {
    @State var opacity = 1.0

    var body: some View {
        ZStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .opacity(0.2)
                
                Text("Search Assistant")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                opacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                ViewRouter.shared.changeView(to: .contentView)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
