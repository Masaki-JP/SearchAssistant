import SearchCore
import SwiftUI
import UIKit

struct FaviconImage: View {
    let platform: SearchPlatform?
    let size: CGFloat?
    
    init(platform: SearchPlatform?, size: CGFloat? = 28) {
        self.platform = platform
        self.size = size
    }
    
    var body: some View {
        Group {
            if let platform, let uiImage = UIImage(resourceName: platform.faviconResourceName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Text(platform?.iconCharacter ?? "?")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.secondary, in: .rect(cornerRadius: 6))
            }
        }
        .frame(width: size, height: size)
    }
}

fileprivate extension UIImage {
    convenience init?(resourceName: String) {
        if UIImage(named: resourceName) != nil {
            self.init(named: resourceName)
            return
        }
        
        guard let bundleImageURL = Bundle.main.url(
            forResource: resourceName,
            withExtension: "png"
        ) else {
            return nil
        }
        
        self.init(contentsOfFile: bundleImageURL.path)
    }
}

#if DEBUG
func previewContent(_ colorScheme: ColorScheme) -> some View {
    ScrollView {
        let columns: [GridItem] = [.init(.adaptive(minimum: 150, maximum: 200), spacing: 18, alignment: .center)]
        
        LazyVGrid(columns: columns, alignment: .center, spacing: 18) {
            ForEach(SearchPlatform.allCases) { platform in
                FaviconImage(platform: platform, size: nil)
            }
        }
    }
    .scrollIndicators(.hidden)
    .contentMargins(.all, 12, for: .scrollContent)
    .preferredColorScheme(colorScheme)
}

#Preview("Light") { previewContent(.light) }
#Preview("Dark") { previewContent(.dark) }
#endif
