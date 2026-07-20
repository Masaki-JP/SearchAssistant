import SwiftUI

struct SearchTextField: View {
    var isFocused: FocusState<Bool>.Binding
    @Binding var userInput: String
    let onSettingsButtonTapped: () -> Void
    let onInputClearButtonTapped: () -> Void
    let onSubmit: () -> Void
    
    @ScaledMetric(relativeTo: .title2) var dynamicTypeScale: CGFloat = 1
    
    func scaledLength(_ baseLength: CGFloat) -> CGFloat {
        dynamicTypeScale * baseLength
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: scaledLength(20))
                .frame(height: scaledLength(22), alignment: .top)
            
            TextField("検索 / Webサイト名入力", text: $userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused(isFocused)
                .onSubmit(onSubmit)
                .frame(height: scaledLength(26))
            
            if userInput.isEmpty == true {
                iconButton(systemName: "gearshape", action: onSettingsButtonTapped)
            } else {
                iconButton(systemName: "x.circle", action: onInputClearButtonTapped)
            }
        }
    }
    
    func iconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(height: scaledLength(20))
                .tint(.primary)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchTextField(
        isFocused: FocusState().projectedValue,
        userInput: .constant("日本代表 試合 日程"),
        onSettingsButtonTapped: {},
        onInputClearButtonTapped: {},
        onSubmit: {}
    )
    .padding(.horizontal)
}
