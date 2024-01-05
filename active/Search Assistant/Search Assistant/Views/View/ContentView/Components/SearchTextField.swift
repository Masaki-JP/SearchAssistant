import SwiftUI

struct SearchTextField: View {
    @ObservedObject private(set) var vm: ViewModel
    @FocusState private(set) var isFocused

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            TextField("What do you search for?", text: $vm.userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused($isFocused)
                .onSubmit {
                    vm.search(vm.userInput)
                }
            if vm.userInput.isEmpty {
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
                    vm.userInput.removeAll()
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
        SearchTextField(vm: ViewModel.shared)
            .previewLayout(.sizeThatFits)
    }
}
