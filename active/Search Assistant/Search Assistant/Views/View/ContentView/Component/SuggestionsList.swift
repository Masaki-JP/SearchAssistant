//
//  SuggestionsList.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/08.
//

import SwiftUI

struct SuggestionsList: View {
    @ObservedObject var vm: ViewModel
    @Binding var input: String
    
    var body: some View {
        List {
            Section {
                ForEach(vm.suggestions.indices, id: \.self) { i in
                    HStack {
                        
                        Button(vm.suggestions[i]) {
                            input.removeAll()
                            vm.Search(vm.suggestions[i])
                        }
//                            .font(.title3)
                        .font(.body)
                            .foregroundStyle(.primary)
                            .padding(.leading, 4)
                        Spacer()
                        Text("on Google")
//                            .font(.caption)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 4)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            } header: {
                Text("Suggestions")
            }
        }
    }
}

#Preview {
    SuggestionsList(vm: ViewModel.shared, input: Binding.constant(""))
}
