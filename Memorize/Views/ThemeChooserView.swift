//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-09-04.
//

import SwiftUI

struct ThemeChooserView: View {
    @ObservedObject var themeStore: ThemeStore
    @State private var games = [String: EmojiMemoryGame]()
    @State private var lastChosenTheme = ""
    @State private var editMode = EditMode.inactive
    @State private var themeToEdit: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(destination: { Text("\(theme.name)") }, label: { themeRow(with: theme) })
                        .gesture(editMode.isEditing ? tap(theme) : nil)
                }
                .onDelete { indexSet in
                    themeStore.deleteTheme(at: indexSet)
                }
                .onMove { indexSet, offset in
                    themeStore.moveTheme(at: indexSet, to: offset)
                }
            }
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("hello")
                    } label: {
                        Image(systemName: "plus")
                    }

                }
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
            .sheet(item: $themeToEdit) { theme in
                if let themeBinding = $themeStore.themes.first(where: { $0.id == theme.id }) {
                    EditThemeView(theme: themeBinding)
                }
            }
        }
    }
    
    // MARK: - Subviews
    func themeRow(with theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(.title)
                .foregroundColor(theme.uiColor)
            
            HStack {
                Text(theme.numberOfPairs == theme.emojis.count ? "All of" : "\(theme.numberOfPairs) pairs from")
                Text(theme.emojis.joined(separator: ""))
                    .lineLimit(1)
            }
        }
    }
    
    
    // MARK: - Gestures
    func tap(_ theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    
    // MARK: - Methods
    func goToGame(with theme: Theme) -> () -> Text {
        print(theme)
        print(theme.id, type(of: theme.id))
        games[theme.id] = EmojiMemoryGame(theme: theme)
        print(games)
        
        let output: () -> Text = {
            Text("\(theme.name)")
        }
        return output
    }
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView(themeStore: ThemeStore())
    }
}
