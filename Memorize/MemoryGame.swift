//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import Foundation

struct MemoryGame<CardContent> {

    private(set) var cards: [Card]

    func choose(_ card: Card) {

    }

    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
}
