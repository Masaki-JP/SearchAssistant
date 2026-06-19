import SwiftUI
import SearchCore

struct SearchButtonsBar: View {
    let platforms: [SearchPlatform]
    let onPlatformButtonTapped: (SearchPlatform?) -> Void
    let onCloseButtonTapped: () -> Void
    
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            primaryCandidate
            secondaryCandidate
        }
        .foregroundStyle(.primary) // ※1
        .font(.title3)
        .padding(.horizontal, 4)
        .fixedSize(horizontal: false, vertical: true)
        .glassEffect()
    }
    
    var primaryCandidate: some View {
        HStack(spacing: .zero) {
            HStack(spacing: .zero) {
                ForEach(platforms) { searchPlatform in
                    Button {
                        onPlatformButtonTapped(searchPlatform)
                    } label: {
                        Text(searchPlatform.displayName)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            xMarkCloseButton
        }
    }
    
    var secondaryCandidate: some View {
        HStack(spacing: .zero) {
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    HStack(spacing: .zero) {
                        ForEach(platforms) { searchPlatform in
                            Button {
                                onPlatformButtonTapped(searchPlatform)
                            } label: {
                                Text(searchPlatform.displayName)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 12)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onChange(of: scenePhase) { _, newScene in
                    if newScene != .active, let scrollDestinationID = platforms.first?.id {
                        scrollViewProxy.scrollTo(scrollDestinationID)
                    }
                }
            }
            
            xMarkCloseButton
        }
    }
    
    var xMarkCloseButton: some View {
        Button {
            onCloseButtonTapped()
        } label: {
            Image(systemName: "x.circle")
                .font(.title2)
                .padding(.horizontal, 4)
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    Rectangle()
        .fill(.gray)
        .ignoresSafeArea()
        .overlay {
            VStack(spacing: 40) {
                SearchButtonsBar(
                    platforms: SearchPlatform.allCases,
                    onPlatformButtonTapped: { print($0?.displayName as Any) },
                    onCloseButtonTapped: { print("closeButton tapped") }
                )
                
                SearchButtonsBar(
                    platforms: [.google, .amazon, .youtube],
                    onPlatformButtonTapped: { print($0?.displayName as Any) },
                    onCloseButtonTapped: { print("closeButton tapped") }
                )
            }
        }
}

/// ※1
/// ボタンの色を変更するために、.foregroundStyle(.primary) を付与している。.buttonStyle(.plain) の方が適しているように思えるが、.buttonStyle(.plain) を使用すると、padding の余白がタップ領域として認識されないため、.foregroundStyle(.primary) を使用する。
