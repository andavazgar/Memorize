//
//  ThemeStore.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-09-04.
//

import SwiftUI

class ThemeStore: ObservableObject {
    @Published var themes = [Theme]() {
        didSet {
            saveThemes()
        }
    }
    
    init() {
        restoreThemes()
        
        if themes.isEmpty {
            themes = Constants.defaultThemes
        }
    }
    
    
    // MARK: - Methods
    private func saveThemes() {
        do {
            let themesData = try JSONEncoder().encode(themes)
            try themesData.write(to: Constants.storageFileURL)
        } catch {
            print("\(String(describing: self)).\(#function) failed: \(error)")
        }
    }
    
    private func restoreThemes() {
        guard Constants.storageFileExists() else { return }
        
        do {
            themes = try JSONDecoder().decode([Theme].self, from: Data(contentsOf: Constants.storageFileURL))
        } catch {
            print("\(String(describing: self)).\(#function) failed: \(error)")
        }
    }
    
    
    // MARK: - Intents
    func addTheme(_ theme: Theme) {
        themes.insert(theme, at: 0)
    }
    
    func deleteTheme(at index: IndexSet) {
        themes.remove(atOffsets: index)
    }
    
    func moveTheme(at indexSet: IndexSet, to offset: Int) {
        themes.move(fromOffsets: indexSet, toOffset: offset)
    }
    
    private struct Constants {
        static let defaultThemes = [
            Theme(name: "Vehicles", emojis: ["🚗", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚠", "🚝", "🚀", "✈️", "🚁"], numberOfPairs: 10, color: .red),
            Theme(name: "Faces", emojis: ["😉", "😄", "😜", "😎", "😁", "😆", "😂", "🤣", "😍", "😘", "🥺", "😤", "🤯", "🥸"], numberOfPairs: 14, color: RGBAColor(color: .orange)),
            Theme(name: "Flags", emojis: ["🇦🇷", "🇧🇷", "🇨🇦", "🇨🇴", "🇪🇨", "🇫🇷", "🇵🇾", "🇵🇪", "🇪🇸", "🇺🇸", "🇻🇪"], numberOfPairs: 8, color: .blue),
            Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏓", "🎱", "🥏", "🥋", "🥊"], numberOfPairs: 10, color: .purple),
            Theme(name: "Music", emojis: ["🎧", "🎼", "🎹", "🥁", "🎷", "🎺", "🪗", "🎸", "🎻", "🎤"], numberOfPairs: 10, color: .green),
            Theme(name: "Electronics", emojis: ["⌚️", "📱", "💻", "🖥", "🖨", "📷", "📹", "📺", "📻", "📽", "🎥"], numberOfPairs: 11, color: .teal)
        ]
        static let storageFileName = "themes.json"
        static let storageFileURL: URL = {
            let fileManager = FileManager.default
            let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            
            if(!fileManager.fileExists(atPath: directory.path)) {
                // Create applicationSupportDirectory
                try? fileManager.createDirectory(at: directory, withIntermediateDirectories: false)
            }
            
            return directory.appendingPathComponent(storageFileName)
        }()
        static let storageFileExists: () -> Bool = {
            FileManager.default.fileExists(atPath: storageFileURL.path)
        }
    }
}


// MARK: - Extensions
extension Theme {
    var uiColor: Color {
        set {
            color = .init(color: newValue)
        }
        get {
            Color(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha)
        }
    }
    
    init(name: String, emojis: [String], numberOfPairs: Int, color: Color) {
        self.init(name: name, emojis: emojis, numberOfPairs: numberOfPairs, color: RGBAColor(color: color))
    }
}

extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
