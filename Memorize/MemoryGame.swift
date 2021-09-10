//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import Foundation

// MARK: - Model

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score: Int = 0

    private var indexOfOneAndOnlyFaceUpCard: Int?

    // TODO: modify to allow iding the last 2 cards when matched
    // TODO: add shuffle / restart
    mutating func choose(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFaceUp,
           !cards[index].isMatched
        {
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[index].content == cards[potentialMatchIndex].content {
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                    print("match", score)
                } else {
                    if cards[index].alreadySeen {
                        score -= 1
                    }
                    print("mismatch", score)
                }
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isFaceUp.toggle()
            cards[index].alreadySeen = true
        }
        // print("\(cards)")
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var alreadySeen = false
        var content: CardContent
        var id: Int
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        var cards = [Card]()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        self.cards = cards.shuffled()
    }
}
