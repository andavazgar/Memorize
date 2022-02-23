//
//  ContentView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.score)")
                Spacer()
                Button("New Game") {
                    viewModel.newGame()
                }
            }
            .font(.title2)
            
            Spacer(minLength: 20)
            
            Text(viewModel.currentTheme.name)
                .font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, cardColor: viewModel.cardColor)
                            .onTapGesture {
                                viewModel.choose(card)
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
    let card: MemoryGame<String>.Card
    let cardColor: Color
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : .white.opacity(0.4))
                cardShape.strokeBorder(lineWidth: 3)
                
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                cardShape.opacity(0)
            } else {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? cardColor.opacity(0.8) : cardColor.opacity(0.6))
                cardShape.strokeBorder(lineWidth: 3)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .foregroundColor(cardColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        Group {
            ContentView(viewModel: game)
            ContentView(viewModel: game)
                .preferredColorScheme(.dark)
//            ContentView()
//                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
