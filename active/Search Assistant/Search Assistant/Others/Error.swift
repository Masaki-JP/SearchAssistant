//
//  Error.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import Foundation

// FIXME: もう少しうまい感じにまとめる


enum HumanError: Error {
    case noInput
    case whiteSpace
}

struct SearchError: Error {}
