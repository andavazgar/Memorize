//
//  CardView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-03-07.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animatedBonusRemaining = 0.0
    private let card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    let pieEndAngle = (1 - animatedBonusRemaining) * 360
                    
                    if card.isConsumingBonusTime {
                        Pie(startAngle: .degrees(0), endAngle: .degrees(pieEndAngle), clockwise: false)
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        let pieEndAngle = (1 - card.bonusRemaining) * 360
                        
                        Pie(startAngle: .degrees(0), endAngle: .degrees(pieEndAngle), clockwise: false)
                    }
                }
                .padding(DrawingConstants.pie.padding)
                .opacity(DrawingConstants.pie.opacity)
                
                Text(card.content)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(
                        .linear(duration: 1).repeatForever(autoreverses: false),
                        value: card.isMatched)
//                    .font(.system(size: fontSize(for: geometry.size)))
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontScale
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        static let pie = (padding: 5.0, opacity: 0.5)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemeStore().themes[0])
        let _ = game.choose(game.cards[0])
        
        Group {
            CardView(game.cards[0])
            CardView(game.cards[0])
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 300))
        .foregroundColor(.orange)
    }
}
