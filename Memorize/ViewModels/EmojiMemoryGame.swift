//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-18.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
    var theme: Theme
    var isGameInProgress = false
    var cards: [Card] {
        model.cards
    }
    var score: Int {
        model.score
    }
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
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
        self.model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
    }
    
    func shuffleCards() {
        model.shuffleCards()
    }
}
