//
//  SearchView.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2023/01/07.
//

import SwiftUI


struct SearchView: View {
    
    // イニシャライザ
    init() {
        UITextField.appearance().tintColor = .white
    }
    
    // アップストレージ
    @AppStorage("autofocus") var autofocus = true
    @AppStorage("searchButton_Left") var searchButton_Left = false
    
    // MySearcherのインスタンス化
    @ObservedObject var mySearcher = MySearcher()
    
    // 環境変数
//    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    
    // ビュー表示のBool値
    @State var showingVoidErrorAlert = false
    @State var showingWhitespaceErrorAlert = false
    @State var showingSettingView = false
    @State var unexpectedErrorAlert = false
    
    // 検索フォームの変数とGoogleSuggestionの配列の変数
    @State var searchWord = ""
    @State var googleSuggestions = [String]()
    
    // フォーカス制御
    @FocusState var focusState: FocusField?
    enum FocusField {
        case search
    }
    
    
    var body: some View {
        ZStack {
            
            Color(red: 0.95, green: 0.95, blue: 0.95).ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                
                
                // 検索フォーム
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.white.opacity(0.7))
                        .frame(width: 20, height: 20).padding(.bottom, 1)
                    ZStack {
                        if searchWord.isEmpty {
                            Text("Search...")
                                .foregroundColor(.white.opacity(0.7)).frame(width: 200, alignment: .leading)
                        }
                        TextField("", text: $searchWord)
                            .foregroundColor(.white).frame(width: 210).background(.clear)
                            .submitLabel(.search)
                            .focused($focusState, equals: .search)
                            .onSubmit {
                                do {
                                    try mySearcher.searchOnGoogle(searchWord: searchWord)
                                    searchWord.removeAll()
                                } catch {
                                    print("error:", error)
                                    if let searchError = error as? humanErrorOnMySearcher, searchError == .void {
                                        showingVoidErrorAlert = true
                                    } else {
                                        unexpectedErrorAlert = true
                                    }
                                }
                            }
                    }
                    if !searchWord.isEmpty {
                        Image(systemName: "xmark.app").foregroundColor(.white.opacity(0.7))
                            .frame(width: 20, height: 20).padding(.top, 1)
                            .onTapGesture {
                                searchWord.removeAll()
                            }
                    } else {
                        Image(systemName: "gearshape").foregroundColor(.white.opacity(0.7))
                            .frame(width: 20, height: 20).padding(.top, 1)
                            .onTapGesture {
                                showingSettingView = true
                            }
                    }
                }
                .scaleEffect(1.3).frame(maxWidth: .infinity, minHeight: 50).background(LinearGradient(gradient: Gradient(colors: [.indigo, .blue, .blue, .cyan, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
                
                
                
                // 検索履歴 & 検索候補
                if searchWord.isEmpty {
                    
                    // 検索履歴
                    ScrollViewReader { reader in
                        ScrollView {
                            VStack(spacing: 0) {
                                Spacer().frame(height: 7)
                                ForEach(Array(mySearcher.searchHistorys.reversed().enumerated()), id: \.element) { index, searchHistory in
                                    
                                    HStack(alignment: .bottom) {
                                        HStack {
                                            Image(systemName: "clock")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .padding(.trailing, 3)
                                                .foregroundColor(.secondary)
                                            
                                            Text(searchHistory.input)
                                                .font(.title3)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color.primary)
                                        }
                                        Spacer()
                                        Text("on " + mySearcher.getPlatform(searchHistory: searchHistory))
                                            .font(.caption2)
                                            .foregroundColor(Color.secondary)
                                            .padding(.leading, 1)
                                    }
                                    .id(index)
                                    .frame(width: UIScreen.main.bounds.width*0.875, alignment: .leading).padding(.leading, 10).padding(.trailing, 10).padding(.top, 12).padding(.bottom, 10).background(Color.white).cornerRadius(10).padding(.vertical, 4)
                                    .onTapGesture {
                                        mySearcher.searchAgain(searchHistory: searchHistory)
                                    }
                                }
                                
                                // 検索履歴の削除ボタン
                                if !mySearcher.searchHistorys.isEmpty {
                                    Button {
                                        mySearcher.searchHistorys.removeAll()
                                        mySearcher.updateUserDefaultSearchHistorys()
                                    } label: {
                                        Text("検索履歴を全て削除")
                                            .font(.title3)
                                            .foregroundColor(.red)
                                            .fontWeight(.semibold)
                                            .padding(.top, 5)
                                    }
                                }
                            } // VStack
                            .frame(width: UIScreen.main.bounds.width)
                        } // ScrollView
                        .onChange(of: scenePhase) { newValue in
                            if newValue == .background {
                                reader.scrollTo(0)
                            }
                        }
                    }
                    
                } else {
                    
                    // 検索候補
                    ScrollView {
                        VStack(spacing: 0) {
                            Spacer().frame(height: 7)
                            
                            ForEach(Array(googleSuggestions.enumerated()), id: \.element) { index, suggestion in
                                Text(suggestion)
                                    .font(.title3).fontWeight(.medium).foregroundColor(.blue).frame(width: UIScreen.main.bounds.width*0.85, alignment: .leading).padding(.leading, 17.5).padding(.trailing, 10).padding(.top, 12).padding(.bottom, 10).background(Color.white).cornerRadius(10).padding(.vertical, 4)
                                    .onTapGesture {
                                        do {
                                            try mySearcher.searchOnGoogle(searchWord: suggestion)
                                            searchWord.removeAll()
                                        } catch {
                                            print(error)
                                            fatalError()
                                        }
                                    }
                            } //ForEach
                        } // VStack
                        .frame(width: UIScreen.main.bounds.width)
                    } // ScrollView
                    
                }
            }
            
            // 検索ボタン
            if focusState == nil {
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            
                            if !searchButton_Left {
                                Spacer()
                            }
                            
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 65, height: 65)
                                    .padding(20)
                                Button {
                                    focusState = .search
                                } label: {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .resizable()
                                        .frame(width: 65, height: 65)
                                        .padding(20)
                                }
                            }
                            
                            if searchButton_Left {
                                Spacer()
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    ScrollViewReader { reader in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                // Twitter検索
                                Button("Twitter") {
                                    do {
                                        try mySearcher.searchOnTwitter(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                .id(0)
                                
                                // Instagram検索
                                Button("Instagram") {
                                    do {
                                        try mySearcher.searchOnInstagram(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.whitespaceError {
                                            showingWhitespaceErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                // Amazon検索
                                Button("Amazon") {
                                    do {
                                        try mySearcher.searchOnAmazon(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                // YouTube検索
                                Button("YouTube") {
                                    do {
                                        try mySearcher.searchOnYouTube(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                Button("Facebook") {
                                    do {
                                        try mySearcher.searchOnFacebook(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                Button("メルカリ") {
                                    do {
                                        try mySearcher.searchOnMercari(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                Button("ラクマ") {
                                    do {
                                        try mySearcher.searchOnRakuma(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                                
                                Button("PayPayフリマ") {
                                    do {
                                        try mySearcher.searchOnPayPayFleaMarket(searchWord: searchWord)
                                        searchWord.removeAll()
                                        reader.scrollTo(0)
                                    } catch {
                                        print(error)
                                        if error as? humanErrorOnMySearcher == humanErrorOnMySearcher.void {
                                            showingVoidErrorAlert = true
                                        } else {
                                            unexpectedErrorAlert = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    // 完了ボタン
                    Button("完了") {
                        focusState = nil
                    }
                }
            }
        }
        .alert("入力内容がありません。", isPresented: $showingVoidErrorAlert) {
            Button("閉じる") {
                showingVoidErrorAlert = false
            }
        }
        .alert("検索エラー", isPresented: $showingWhitespaceErrorAlert) {
            Button("閉じる") {
                showingWhitespaceErrorAlert = false
            }
        } message: {
            Text("Instagram検索では、入力されたキーワードのタグ検索を行うため、空白スペースは使用できません。")
        }
        .alert("予期せぬエラーが発生しました。", isPresented: $unexpectedErrorAlert) {
            Button("閉じる") {
                unexpectedErrorAlert = false
            }
        }
        .sheet(isPresented: $showingSettingView) {
            SettingView()
        }
        .onAppear {
            if autofocus {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    focusState = .search
                }
            }
        }
        .onChange(of: searchWord) { newValue in
            
            guard newValue != "" else {
                googleSuggestions.removeAll()
                return
            }
            
            Task {
                do {
                    googleSuggestions = try await mySearcher.getGoogleSuggestions(searchWord: newValue)
                } catch {
                    print(error)
                    googleSuggestions.removeAll()
                    googleSuggestions.append("検索候補の取得に失敗しました。")
                }
            }
            
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                if autofocus {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                        focusState = .search
                    }
                }
            case .inactive:
                showingSettingView = false
            case .background:
                showingSettingView = false
            @unknown default:
                fatalError()
            }
        }
    }
}




struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
