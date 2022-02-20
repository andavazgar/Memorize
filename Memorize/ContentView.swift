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
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .foregroundColor(.red)
            }
            
            HStack {
                ForEach(0..<EmojiMemoryGame.themes.count) { index in
                    let theme = EmojiMemoryGame.themes[index]
                    
                    Button {
                        viewModel.setCurrentTheme(withIndex: index)
                    } label: {
                        VStack {
                            Image(systemName: theme.icon)
                                .font(.title)
                            Text(theme.name)
                        }
                        .foregroundColor(index == viewModel.currentTheme ? .red : .accentColor)
                    }
                    .frame(maxWidth: .infinity)
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
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : Color(uiColor: .lightGray))
                cardShape.strokeBorder(lineWidth: 3)
                
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                cardShape.opacity(0)
            } else {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : Color(uiColor: .lightGray))
                cardShape.strokeBorder(lineWidth: 3)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
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
