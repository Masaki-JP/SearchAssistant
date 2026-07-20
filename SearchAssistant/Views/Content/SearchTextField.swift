import SwiftUI

struct SearchTextField: View {
    var isFocused: FocusState<Bool>.Binding
    @Binding var userInput: String
    let onSettingsButtonTapped: () -> Void
    let onInputClearButtonTapped: () -> Void
    let onSubmit: () -> Void
    
    @ScaledMetric(relativeTo: .title2) var iconHight: CGFloat = 20
    @ScaledMetric(relativeTo: .title2) var magnifyingglassIconFrameHight: CGFloat = 22
    @ScaledMetric(relativeTo: .title2) var textFieldHight: CGFloat = 26
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: iconHight)
                .frame(height: magnifyingglassIconFrameHight, alignment: .top)
            
            TextField("検索 / Webサイト名入力", text: $userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused(isFocused)
                .onSubmit(onSubmit)
                .frame(height: textFieldHight)
            
            if userInput.isEmpty == true {
                settingsButton
            } else {
                clearButton
            }
        }
    }
    
    var settingsButton: some View {
        Button {
            onSettingsButtonTapped()
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .scaledToFit()
                .frame(height: iconHight)
                .tint(.primary)
        }
    }
    
    var clearButton: some View {
        Button {
            onInputClearButtonTapped()
        } label: {
            Image(systemName: "x.circle")
                .resizable()
                .scaledToFit()
                .frame(height: iconHight)
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
