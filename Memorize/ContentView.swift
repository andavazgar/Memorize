//
//  ContentView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

struct ContentView: View {
    @State private var emojis = ["😉", "😄", "😜", "😎"]
    @State private var emojiCount = 2
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(emojis[0..<emojiCount], id:\.self) { emoji in
                        CardView(content: emoji)
                    }
                }
                .foregroundColor(.red)
            }
            
            Spacer()
            
            HStack {
                removeButton
                Spacer()
                shuffleButton
                Spacer()
                addButton
            }
            .font(.title)
            .padding(.horizontal)
        }
        .padding()
    }
    
    var addButton: some View {
        Button {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
        .disabled(emojiCount == emojis.count)
        .foregroundColor(buttonColor(isDisabled: emojiCount == emojis.count))
    }
    
    var removeButton: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
        .disabled(emojiCount == 1)
        .foregroundColor(buttonColor(isDisabled: emojiCount == 1))
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            
        }
    }
    
    func buttonColor(isDisabled: Bool) -> Color {
        return isDisabled ? .gray : .accentColor
    }
}

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isFaceUp = true
    let content: String
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : Color(uiColor: .lightGray))
                
                Text(content).font(.largeTitle)
            } else {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : Color(uiColor: .lightGray))
            }
            cardShape.strokeBorder(lineWidth: 3)
        }
        .aspectRatio(2/3, contentMode: .fit)
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
