//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import SwiftUI

// MARK: - View Model

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    private static let emojis = ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "🚜", "🚞", "✈️"]

    private static func createMemoryGameModel() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGameModel()

    var cards: [Card] {
        return model.cards
    }

    // MARK: - Intent

    func choose(_ card: Card) {
        // objectWillChange.send() // implicit in Published
        model.choose(card)
    }
}
