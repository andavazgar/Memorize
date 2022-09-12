//
//  Theme.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-20.
//

import Foundation

struct Theme: Codable, Hashable, Identifiable {
    private(set) var id = UUID().uuidString
    var name: String
    var emojis: [String]
    var numberOfPairs: Int
    var color: RGBAColor
}
