//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-18.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let themes = [
        Theme(name: "Vehicles", emojis: ["🚗", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚠", "🚝", "🚀", "✈️", "🚁"], numberOfPairs: 10, color: "red"),
        Theme(name: "Faces", emojis: ["😉", "😄", "😜", "😎", "😁", "😆", "😂", "🤣", "😍", "😘", "🥺", "😤", "🤯", "🥸"], numberOfPairs: 14, color: "orange"),
        Theme(name: "Flags", emojis: ["🇦🇷", "🇧🇷", "🇨🇦", "🇨🇴", "🇪🇨", "🇫🇷", "🇵🇾", "🇵🇪", "🇪🇸", "🇺🇸", "🇻🇪"], numberOfPairs: 8, color: "blue"),
        Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏓", "🎱", "🥏", "🥋", "🥊"], numberOfPairs: 10, color: "purple"),
        Theme(name: "Music", emojis: ["🎧", "🎼", "🎹", "🥁", "🎷", "🎺", "🪗", "🎸", "🎻", "🎤"], numberOfPairs: 10, color: "green"),
        Theme(name: "Electronics", emojis: ["⌚️", "📱", "💻", "🖥", "🖨", "📷", "📹", "📺", "📻", "📽", "🎥"], numberOfPairs: 11, color: "fuchsia")
    ]
    
    @Published private var model: MemoryGame<String>
    private var currentThemeIndex: Int {
        didSet {
            model = EmojiMemoryGame.createMemoryGame(withTheme: currentTheme)
        }
    }
    var currentTheme: Theme {
        EmojiMemoryGame.themes[currentThemeIndex]
    }
    var cards: [Card] {
        model.cards
    }
    var score: Int {
        model.score
    }
    var cardColor: Color {
        switch currentTheme.color {
        case "blue":
            return .blue
        case "green":
            return .green
        case "orange":
            return .orange
        case "purple":
            return .purple
        default:
            return .red
        }
    }
    
    init() {
        self.currentThemeIndex = Int.random(in: EmojiMemoryGame.themes.indices)
        self.model = EmojiMemoryGame.createMemoryGame(withTheme: EmojiMemoryGame.themes[currentThemeIndex])
    }
    
    private static func createMemoryGame(withTheme theme: Theme) -> MemoryGame<String> {
        var emojis = theme.emojis
        let numberOfPairs = theme.numberOfPairs > theme.emojis.count ? theme.emojis.count : theme.numberOfPairs
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { _ in
            let emojiIndex = Int.random(in: emojis.indices)
            return emojis.remove(at: emojiIndex)
        }
    }
    
    
    
    // MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        var rangeOfThemeIndices = Array(EmojiMemoryGame.themes.indices)
        rangeOfThemeIndices.remove(at: currentThemeIndex)
        currentThemeIndex = rangeOfThemeIndices.randomElement() ?? 0
    }
    
    func shuffleCards() {
        model.shuffleCards()
    }
}
