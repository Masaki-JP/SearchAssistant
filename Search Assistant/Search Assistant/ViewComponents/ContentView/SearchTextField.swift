import SwiftUI

struct SearchTextField: View {
    @ObservedObject private var vm: ContentViewModel
    private var isFocused: FocusState<Bool>.Binding

    init(
        vm: ContentViewModel,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.vm = vm
        self.isFocused = isFocused
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            TextField("What do you search for?", text: $vm.userInput)
                .font(.title2)
                .submitLabel(.search)
                .focused(isFocused)
                .onSubmit {
                    vm.search(vm.userInput, on: .google)
                }
            Button(action: {
                vm.userInput.isEmpty
                ? vm.isPresentedSettingView = true
                : vm.userInput.removeAll()
            }, label: {
                Image(systemName: vm.userInput.isEmpty ? "gearshape" : "x.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .tint(.primary)
            })
        }
    }
}

//#Preview {
//    SearchTextField(vm: ContentViewModel.shared, userInput: Binding.constant(""))
//        .padding(.horizontal)
//}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(
            vm: ContentViewModel(),
            isFocused: FocusState<Bool>().projectedValue
        )
        .previewLayout(.sizeThatFits)
        .padding(.horizontal)
    }
}
