//
//  EditThemeView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-09-06.
//

import SwiftUI

struct EditThemeView: View {
    @Binding var theme: Theme
    @State private var emojisToAdd = ""
    @State private var cardCount: Int
    @Environment(\.dismiss) private var dismiss
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._cardCount = State(initialValue: theme.wrappedValue.numberOfPairs)
    }
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                emojisSection
                addEmojiSection
                cardCountSection
                colorSection
            }
            .navigationTitle("\(theme.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Close", action: { dismiss() })
            }
        }
    }
    
    var nameSection: some View {
        Section {
            TextField("Name", text: $theme.name)
        } header: { SectionHeaderText("Theme Name") }
    }
    
    var emojisSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.emojiSize))]) {
                ForEach(theme.emojis.uniqued, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll { $0 == emoji }
                            }
                        }
                }
                
            }
            .font(.system(size: Constants.emojiSize))
        } header: {
            HStack {
                SectionHeaderText("Emojis")
                Spacer()
                Text("TAP EMOJI TO EXCLUDE")
                    .font(.caption)
            }
        }

    }
    
    var addEmojiSection: some View {
        Section {
            TextField("Emoji", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { newEmoji in
                    if(newEmoji.isEmoji) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            emojisToAdd = ""
                            addEmoji(newEmoji)
                        }
                    } else {
                        emojisToAdd = ""
                    }
                }
        } header: { SectionHeaderText("Add Emoji") }
    }
    
    var cardCountSection: some View {
        Section {
            Stepper(value: $cardCount, in: 2...theme.emojis.count, step: 1) {
                if cardCount == theme.emojis.count {
                    Text("All pairs (\(cardCount))")
                } else {
                    Text("\(cardCount) Pairs")
                }
            } onEditingChanged: { isEditing in
                if(!isEditing) {
                    theme.numberOfPairs = cardCount
                }
            }

        } header: {
            SectionHeaderText("Card Count")
        }

    }
    
    var colorSection: some View {
        let colors: [Color] = [.red, .blue, .orange, .purple, .green, .gray]
        
        return Section {
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .padding(5)
                        .overlay(content: {
                            Constants.color.borderShape
                                .stroke(Constants.color.borderColor, lineWidth: theme.color == RGBAColor(color: color) ? Constants.color.borderWidth : 0)
                        })
                        .onTapGesture {
                            theme.uiColor = color
                        }
                }
                
                ColorPicker("", selection: $theme.uiColor)
                    .labelsHidden()
            }
            .frame(height: Constants.color.frameHeight)
        } header: {
            SectionHeaderText("Color")
        }

    }
    
    
    // MARK: - Methods
    func addEmoji(_ emoji: String) {
        theme.emojis = ([emoji] + theme.emojis).uniqued
    }
    
    
    // MARK: - Constants
    private struct Constants {
        static let emojiSize = 40.0
        static let color = (
            frameHeight: 38.0,
            borderShape: RoundedRectangle(cornerRadius: 5),
            borderColor: Color.blue.opacity(0.6),
            borderWidth: 2.0
        )
    }
}


struct SectionHeaderText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text.uppercased())
            .font(.subheadline.bold())
    }
}


// MARK: - Preview
struct EditThemeView_Previews: PreviewProvider {
    static var previews: some View {
        EditThemeView(theme: .constant(ThemeStore().themes[0]))
    }
}
