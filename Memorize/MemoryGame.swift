//
//  MemoryGame.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-18.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score = 0
    private var currentFaceUpCardIndex: Int? {
        let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp }
        return faceUpIndices.count == 1 ? faceUpIndices.first : nil
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[cardIndex].isFaceUp && !cards[cardIndex].isMatched
        else { return }
        
        if let potentialMatchIndex = currentFaceUpCardIndex {
            if cards[cardIndex].content == cards[potentialMatchIndex].content {
                cards[cardIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                score += 2
            } else if cards[cardIndex].hasBeenSeen || cards[potentialMatchIndex].hasBeenSeen {
                score -= 1
            }
            
            cards[cardIndex].hasBeenSeen = true
            cards[potentialMatchIndex].hasBeenSeen = true
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
        }
        
        cards[cardIndex].isFaceUp.toggle()
    }
    
    
    struct Card: Identifiable {
        let id: Int
        var isFaceUp = false
        var isMatched = false
        var hasBeenSeen = false
        let content: CardContent
    }
}
