import SwiftUI

struct HistoryList: View {
    @ObservedObject private(set) var vm: ViewModel

    var body: some View {
        if vm.historys.isEmpty == false {
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
                        .foregroundStyle(.primary)
                    }
                    .onDelete { indexSet in
                        vm.removeHistory(atOffsets: indexSet)
                    }
                } header: {
                    Text("Historys")
                        .textCase(.none)
                } footer: {
                    if vm.historys.isEmpty == false {
                        Button("全履歴を削除", role: .destructive) {
                            vm.isShowPromptToConfirmDeletionOFAllHistorys = true
                        }
                        .font(.title3)
                        .disabled(vm.historys.isEmpty)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                    }
                }
            }
        } else {
            VStack(spacing: 5) {
                Spacer()
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundStyle(.secondary)
                Text("I am Search Assistant!")
                    .fontWeight(.bold)
                    .font(.title2)
                Text("Google, Twitter, Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Spacer()
            }
        }
    }
}

#Preview {
    HistoryList(vm: ViewModel.shared)
}
