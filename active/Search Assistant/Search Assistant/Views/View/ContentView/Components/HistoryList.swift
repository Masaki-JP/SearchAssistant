import SwiftUI

struct HistoryList: View {
    @ObservedObject private(set) var vm: ViewModel

    var body: some View {
        List {
            Section {
                ForEach(vm.historys) { history in
                    Button(action: {
                        vm.search(history.userInput, on: history.platform)
                    }, label: {
                        HStack {
                            Text(history.platform.iconCharacter)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                                .background(history.platform.imageColor)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            Text(history.userInput)
                                .padding(.leading, 4)
                            Spacer()
                            Text(vm.getDateString(from: history.date))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 4)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    })
                }
                .onDelete { indexSet in
                    vm.removeHistory(atOffsets: indexSet)
                }
            } header: {
                Text("Historys")
                    .textCase(.none)
            } footer: {
                HStack {
                    Spacer()
                    Button {
                        vm.isShowPromptToConfirmDeletionOFAllHistorys = true
                    } label: {
                        Text("全履歴を削除")
                            .foregroundStyle(vm.historys.isEmpty ? .gray : .red)
                            .font(.title3)
                    }
                    .disabled(vm.historys.isEmpty)
                    Spacer()
                }
                .padding(.top, 5)
            }
        }
    }
}

#Preview {
    HistoryList(vm: ViewModel.shared)
}
