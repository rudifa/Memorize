//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "🚜", "🚞", "✈️"]

    static func createMemoryGameModel() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGameModel()

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }

    // MARK: - Intent

    func choose(_ card: MemoryGame<String>.Card) {
        // objectWillChange.send() // implicit in Published
        model.choose(card)
    }
}
