import SwiftUI

struct SearchTextField: View {
    @ObservedObject var vm: ViewModel
    @Binding var userInput: String
    @FocusState var isFocused
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            TextField("What do you search for?", text: $userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused($isFocused)
                .onSubmit {
                    vm.search(userInput)
                    userInput.removeAll()
                }
            if userInput.isEmpty {
                Button(action: {
                    vm.isPresesntedSettingsView = true
                }, label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .tint(.primary)
                })
            } else {
                Button(action: {
                    userInput.removeAll()
                }, label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .tint(.primary)
                })
            }
                
        }
    }
}

//#Preview {
//    SearchTextField(vm: ViewModel.shared, userInput: Binding.constant(""))
//        .padding(.horizontal)
//}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(vm: ViewModel.shared, userInput: Binding.constant(""))
            .previewLayout(.sizeThatFits)
    }
}
