//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(game.score)")
                Spacer()
                Button("New Game") {
                    game.newGame()
                }
            }
            .font(.title2)
            
            Spacer(minLength: 20)
            
            Text(game.currentTheme.name)
                .font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(game.cards) { card in
                        CardView(card, color: game.cardColor)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
        }
        .padding()
    }
    
    func buttonColor(isDisabled: Bool) -> Color {
        return isDisabled ? .gray : .accentColor
    }
}

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    private let card: EmojiMemoryGame.Card
    private let cardColor: Color
    
    init(_ card: EmojiMemoryGame.Card, color: Color) {
        self.card = card
        self.cardColor = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                if card.isFaceUp {
                    cardShape.fill()
                        .foregroundColor(colorScheme == .light ? .white : .white.opacity(0.4))
                    cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    
                    Text(card.content)
                        .font(.system(size: fontSize(for: geometry.size)))
                } else if card.isMatched {
                    cardShape.opacity(0)
                } else {
                    cardShape.fill()
                        .foregroundColor(colorScheme == .light ? cardColor.opacity(0.8) : cardColor.opacity(0.6))
                    cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .foregroundColor(cardColor)
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontScale
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let fontScale: CGFloat = 0.7
        static let lineWidth: CGFloat = 3
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        Group {
            EmojiMemoryGameView(game: game)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
//            ContentView()
//                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
