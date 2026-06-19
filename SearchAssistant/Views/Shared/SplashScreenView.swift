import SwiftUI
import SwiftData

struct SplashScreenView: View {
    @Environment(\.modelContext) var modelContext
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
