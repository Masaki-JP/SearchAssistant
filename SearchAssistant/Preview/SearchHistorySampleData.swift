import SwiftUI
import SwiftData

struct SearchHistorySampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: true
        )
        
        let container = try ModelContainer(
            for: SearchHistory.self,
            configurations: configuration
        )
        
        SearchHistory.samples.forEach { searchHistory in
            container.mainContext.insert(searchHistory)
        }
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var searchHistorySampleData: Self {
        .modifier(SearchHistorySampleData())
    }
}
