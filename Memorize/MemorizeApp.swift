//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-01-06.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        let game = EmojiMemoryGame()
        
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
