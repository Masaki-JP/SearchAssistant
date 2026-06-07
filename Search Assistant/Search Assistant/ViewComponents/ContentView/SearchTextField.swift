import SwiftUI

struct SearchTextField: View {
    var isFocused: FocusState<Bool>.Binding
    @Binding var userInput: String
    let onSettingsButtonTapped: () -> Void
    let onInputClearButtonTapped: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            TextField("What do you search for?", text: $userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused(isFocused)
                .onSubmit(onSubmit)
            if userInput.isEmpty == true {
                Button {
                    onSettingsButtonTapped()
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .tint(.primary)
                }
            } else {
                Button {
                    onInputClearButtonTapped()
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .tint(.primary)
                }
            }
        }
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(
            isFocused: FocusState().projectedValue,
            userInput: .constant("apple"),
            onSettingsButtonTapped: {},
            onInputClearButtonTapped: {},
            onSubmit: {}
        )
        .previewLayout(.sizeThatFits)
        .padding(.horizontal)
    }
}
