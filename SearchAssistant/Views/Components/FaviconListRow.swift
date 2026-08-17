import SearchCore
import SwiftUI

struct FaviconListRow: View {
    let platform: SearchPlatform?
    let title: String
    
    init(
        platform: SearchPlatform?,
        title: String,
    ) {
        self.platform = platform
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 10) {
            FaviconImage(platform: platform)
            Text(title) .lineLimit(1)
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in -5 }
    }
}

#Preview {
    List {
        FaviconListRow(platform: .googleMaps, title: "名古屋駅")                
        FaviconListRow(platform: .youtube, title: "iPhone Fold")
    }
}
