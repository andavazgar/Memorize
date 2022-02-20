//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-18.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    struct Theme: Hashable {
        let name: String
        let icon: String
        let emojis: [String]
    }
    
    static let themes = [
        Theme(name: "Vehicles", icon: "car", emojis: ["🚗", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚠", "🚝", "🚀", "✈️", "🚁"]),
        Theme(name: "Faces", icon: "face.smiling", emojis: ["😉", "😄", "😜", "😎", "😁", "😆", "😂", "🤣", "😍", "😘", "🥺", "😤", "🤯", "🥸"]),
        Theme(name: "Flags", icon: "flag", emojis: ["🇦🇷", "🇧🇷", "🇨🇦", "🇨🇴", "🇪🇨", "🇫🇷", "🇵🇾", "🇵🇪", "🇪🇸", "🇺🇸", "🇻🇪"])
    ]
    
    @Published private var model: MemoryGame<String>
    private(set) var currentTheme: Int {
        didSet {
            model = EmojiMemoryGame.createMemoryGame(withThemeIndex: currentTheme)
        }
    }
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    init() {
        self.currentTheme = 0
        self.model = EmojiMemoryGame.createMemoryGame(withThemeIndex: currentTheme)
    }
    
    static func createMemoryGame(withThemeIndex themeIndex: Int) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            EmojiMemoryGame.themes[themeIndex].emojis[pairIndex]
        }
    }
    
    // MARK: - Intents
    
    func setCurrentTheme(withIndex index: Int) {
        if (0..<EmojiMemoryGame.themes.count).contains(index) {
            currentTheme = index
        }
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
