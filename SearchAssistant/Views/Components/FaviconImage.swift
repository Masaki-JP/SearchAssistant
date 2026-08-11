import SearchCore
import SwiftUI
import UIKit

struct FaviconImage: View {
    let platform: SearchPlatform?
    
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
        .frame(width: 28, height: 28)
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
