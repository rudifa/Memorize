//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rudolf Farkas on 04.09.21.
//

import SwiftUI

// MARK: - ViewModel

enum Theme: Int, CaseIterable {
    case vehicles
    case zodiac
    case euFlags
    case chess

    struct Data {
        let buttonImageName: String
        let name: String
        let emojis: [String]
        let minCountToUse: Int
        let cardColor: Color
    }

    static func data(_ selected: Theme) -> Data {
        switch selected {
        case .vehicles:
            return Data(buttonImageName: "car",
                        name: "Vehicles",
                        emojis: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "✈️"],
                        minCountToUse: 6,
                        cardColor: .red)

        case .zodiac:
            return Data(buttonImageName: "wand.and.stars",
                        name: "Zodiac",
                        emojis: ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"],
                        minCountToUse: 10,
                        cardColor: .purple)

        case .euFlags:
            return Data(buttonImageName: "flag",
                        name: "EU flags",
                        emojis: ["🇦🇹", "🇧🇪", "🇧🇬", "🇭🇷", "🇨🇾", "🇨🇿", "🇩🇰", "🇪🇪", "🇫🇮", "🇫🇷", "🇩🇪", "🇬🇷", "🇭🇺", "🇮🇪", "🇮🇹", "🇱🇻", "🇱🇹", "🇱🇺", "🇲🇹", "🇳🇱", "🇵🇱", "🇵🇹", "🇷🇴", "🇸🇰", "🇸🇮", "🇪🇸", "🇸🇪"],
                        minCountToUse: 8,
                        cardColor: .blue)

        /* European Union Countries
               Austria, Belgium, Bulgaria, Croatia, Cyprus, Czech Republic,
               Denmark, Estonia, Finland, France, Germany, Greece,
               Hungary, Ireland, Italy, Latvia, Lithuania, Luxembourg,
               Malta, Netherlands, Poland, Portugal, Romania, Slovakia
               Slovenia, Spain, Sweden
         */
        case .chess:
            return Data(buttonImageName: "checkerboard.rectangle", name: "Chess", emojis: ["♔", "♕", "♖", "♗", "♘", "♙", "♚", "♛", "♜", "♝", "♞", "♟"], minCountToUse: 5, cardColor: .gray)
        }
    }

    static func randomEmojis(from theme: Theme) -> [String] {
        let data = Theme.data(theme)
        let minCount = min(data.emojis.count, data.minCountToUse)
        let count = minCount + Int.random(in: 0 ... data.emojis.count - minCount)
        print("count= \(count) of \(data.emojis.count)")
        return [String](data.emojis.shuffled()[..<count])
    }

    static var random: Theme {
        let index = Int.random(in: 0 ..< Self.allCases.count)
        return Self(rawValue: index)!
    }
}

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var model: MemoryGame<String>!
    @Published private(set) var title: String!
    @Published private(set) var cardColor: Color!
    @Published private(set) var score: Int!
    @Published private(set) var maxScore: Int!

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }

    private func createMemoryGameModel(theme: Theme) {
        let emojis = Theme.randomEmojis(from: theme)
        model = MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
        title = Theme.data(theme).name
        cardColor = Theme.data(theme).cardColor
        score = model.score
        maxScore = cards.count
    }

    init() {
        newGame()
    }

    // MARK: - Intent

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        score = model.score
    }

    func newGame() {
        createMemoryGameModel(theme: Theme.random)
    }
}
