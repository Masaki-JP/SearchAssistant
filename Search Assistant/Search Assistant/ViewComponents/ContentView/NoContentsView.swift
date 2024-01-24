import SwiftUI

struct NoContentsView: View {
    private let title: String
    private let description: String?
    private let imageSystemName: String

    init(
        title: String,
        description: String? = nil,
        imageSystemName: String
    ) {
        self.title = title
        self.description = description
        self.imageSystemName = imageSystemName
    }

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundStyle(.secondary)
            Text(title)
                .fontWeight(.bold)
                .font(.title2)

            if let description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        }
        .frame(width: 350)
    }
}

#Preview {
    NoContentsView(
        title: "I am Search Assistant!",
        description: "Google, Twitter, Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。",
        imageSystemName: "doc.text.magnifyingglass"
    )
}
