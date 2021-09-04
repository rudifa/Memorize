//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "🚜", "🚞", "✈️"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 20) { pairIndex in
            emojis[pairIndex]
        }
    }

    private(set) var model = createMemoryGame()

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
}
