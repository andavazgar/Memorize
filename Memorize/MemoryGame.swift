//
//  MemoryGame.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-18.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var currentFaceUpCardIndex: Int?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        
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
            }
            currentFaceUpCardIndex = nil
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
            
            currentFaceUpCardIndex = cardIndex
        }
        
        cards[cardIndex].isFaceUp.toggle()
    }
    
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
