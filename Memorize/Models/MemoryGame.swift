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
    
    mutating func shuffleCards() {
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var hasBeenSeen = false
        let content: CardContent
        
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e.: not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time is left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // wether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // wether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
