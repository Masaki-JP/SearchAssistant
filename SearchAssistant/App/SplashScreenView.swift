import SwiftUI
import SwiftData

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) var modelContext
    @State var opacity = 1.0
    let size: CGFloat = 280
    
    var body: some View {
        VStack(spacing: .zero) {
            Image("SplashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .accessibilityHidden(true)
            
            Text("Search Assistant")
                .foregroundStyle(textColor)
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.leading, 16)
                .padding(.top, -16)
        }
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .opacity(opacity)
        .task(afterAppear)
    }
    
    var textColor: Color {
        colorScheme == .light
        ? Color(red: 62/255*0.9, green: 65/255*0.9, blue: 74/255*0.9)
        : .primary
    }
    
    var backgroundColor: AnyGradient {
        colorScheme == .light
        ? Color(red: 0.975, green: 0.975, blue: 0.975).gradient
        : Color.black.gradient
    }
    
    func afterAppear() async {
        migrateSearchHistoriesToSwiftDataIfNeeded()
        
        try? await Task.sleep(for: .seconds(0.5))
        
        withAnimation(.easeOut(duration: 1.0)) {
            opacity = .zero
        }
        
        try? await Task.sleep(for: .seconds(1.25))
        
        ViewRouter.shared.changeView(to: .contentView)
    }
    
    func migrateSearchHistoriesToSwiftDataIfNeeded() {
        do {
            try SearchHistoryMigration.migrateIfNeeded(using: modelContext)
        } catch {
            reportError(error)
        }
    }
}

#Preview {
    SplashScreenView()
}
