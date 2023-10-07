//
//  Error.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import Foundation

// FIXME: もう少しうまい感じにまとめる

// たしか検索のときに投げられるかもしれないエラー。
enum HumanError: Error {
    case noInput
    case whiteSpace
}

struct SearchError: Error {}
