//
//  ContentView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

struct Theme: Hashable {
    let name: String
    let icon: String
    let emojis: [String]
}

struct ContentView: View {
    let themes = [
        Theme(name: "Vehicles", icon: "car", emojis: ["🚗", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚠", "🚝", "🚀", "✈️", "🚁"]),
        Theme(name: "Faces", icon: "face.smiling", emojis: ["😉", "😄", "😜", "😎", "😁", "😆", "😂", "🤣", "😍", "😘", "🥺", "😤", "🤯", "🥸"]),
        Theme(name: "Flags", icon: "flag", emojis: ["🇦🇷", "🇧🇷", "🇨🇦", "🇨🇴", "🇪🇨", "🇫🇷", "🇵🇾", "🇵🇪", "🇪🇸", "🇺🇸", "🇻🇪"])
    ]
    @State private var currentTheme = 0
    var emojis: [String] {
        let listOfEmojis = themes[currentTheme].emojis
        let numberOfCards = Int.random(in: 4...listOfEmojis.count)
        let cardsToDisplay = listOfEmojis[0..<numberOfCards]
        
        return Array(cardsToDisplay).shuffled()
    }
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                    ForEach(emojis, id:\.self) { emoji in
                        CardView(content: emoji)
                    }
                }
                .foregroundColor(.red)
            }
            
            HStack {
                ForEach(0..<themes.count) { index in
                    let theme = themes[index]
                    
                    Button {
                        currentTheme = index
                    } label: {
                        VStack {
                            Image(systemName: theme.icon)
                                .font(.title)
                            Text(theme.name)
                        }
                        .foregroundColor(index == currentTheme ? .red : .accentColor)
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
//            ContentView()
//                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
