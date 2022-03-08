//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = EmojiMemoryGame.Card
    
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    @State private var dealtCards = Set<Int>()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                header
                gameBody
                shuffleButton
            }
            .padding()
            
            deckOfCards
        }
    }
    
    // MARK: - Views
    private var header: some View {
        VStack {
            HStack {
                Text("Score: \(game.score)")
                Spacer()
                Button("New Game") {
                    withAnimation {
                        dealtCards = []
                        game.newGame()
                    }
                }
            }
            .font(.title2)
            .padding(.bottom)
            
            Text(game.currentTheme.name)
                .font(.largeTitle)
        }
    }
    
    private var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isInDeck(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.75)) {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(game.cardColor)
    }
    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 0.5)) {
                game.shuffleCards()
            }
        }
        .font(.title2)
        .opacity(game.cards.count == dealtCards.count ? 1 : 0)
    }
    
    private var deckOfCards: some View {
        ZStack {
            ForEach(game.cards.filter(isInDeck)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.widthOfDeckCards, height: CardConstants.heightOfDeckCards)
        .foregroundColor(game.cardColor)
        .onTapGesture {
            // deal cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    dealCard(card)
                }
            }
        }
    }
    
    
    // MARK: - Methods
    private func dealCard(_ card: Card) {
        dealtCards.insert(card.id)
    }
    
    private func isInDeck(_ card: Card) -> Bool {
        !dealtCards.contains(card.id)
    }
    
    private func dealAnimation(for card: Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private func buttonColor(isDisabled: Bool) -> Color {
        return isDisabled ? .gray : .accentColor
    }
    
    // MARK: - Constants
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration = 0.5
        static let totalDealDuration = 2.0
        static let heightOfDeckCards = 90.0
        static let widthOfDeckCards = heightOfDeckCards * aspectRatio
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        let _: Void = game.choose(game.cards[0])
        
        Group {
            EmojiMemoryGameView(game: game)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
        }
    }
}
