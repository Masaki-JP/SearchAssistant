import SwiftUI

struct SearchTextField: View {
    @ObservedObject var vm: ViewModel
    @Binding var input: String
    @FocusState var isFocused
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            TextField("What do you search for?", text: $input)
                .font(.title2)
                .submitLabel(.search)
                .focused($isFocused)
                .onSubmit {
                    vm.Search(input)
                    input.removeAll()
                }
            if input.isEmpty {
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
                    input.removeAll()
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
//    SearchTextField(vm: ViewModel.shared, input: Binding.constant(""))
//        .padding(.horizontal)
//}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(vm: ViewModel.shared, input: Binding.constant(""))
            .previewLayout(.sizeThatFits)
    }
}
