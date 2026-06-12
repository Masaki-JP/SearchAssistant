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
        .task(afterAppear)
    }
    
    func afterAppear() async {
        try? await Task.sleep(for: .seconds(0.5))
        
        withAnimation(.easeOut(duration: 1.0)) {
            opacity = .zero
        }
        
        try? await Task.sleep(for: .seconds(1.25))
        
        ViewRouter.shared.changeView(to: .contentView)
    }
}

#Preview {
    SplashScreenView()
}
