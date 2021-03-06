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
        Theme(name: "Vehicles", emojis: ["π", "π", "π", "π", "π", "π", "π", "π ", "π", "π", "βοΈ", "π"], numberOfPairs: 10, color: "red"),
        Theme(name: "Faces", emojis: ["π", "π", "π", "π", "π", "π", "π", "π€£", "π", "π", "π₯Ί", "π€", "π€―", "π₯Έ"], numberOfPairs: 14, color: "orange"),
        Theme(name: "Flags", emojis: ["π¦π·", "π§π·", "π¨π¦", "π¨π΄", "πͺπ¨", "π«π·", "π΅πΎ", "π΅πͺ", "πͺπΈ", "πΊπΈ", "π»πͺ"], numberOfPairs: 8, color: "blue"),
        Theme(name: "Sports", emojis: ["β½οΈ", "π", "π", "βΎοΈ", "πΎ", "π", "π", "π±", "π₯", "π₯", "π₯"], numberOfPairs: 10, color: "purple"),
        Theme(name: "Music", emojis: ["π§", "πΌ", "πΉ", "π₯", "π·", "πΊ", "πͺ", "πΈ", "π»", "π€"], numberOfPairs: 10, color: "green"),
        Theme(name: "Electronics", emojis: ["βοΈ", "π±", "π»", "π₯", "π¨", "π·", "πΉ", "πΊ", "π»", "π½", "π₯"], numberOfPairs: 11, color: "fuchsia")
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
