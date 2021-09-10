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

    struct Data {
        let buttonImageName: String
        let name: String
        let emojis: [String]
        let minCountToUse: Int
    }

    static func data(_ selected: Theme) -> Data {
        switch selected {
        case .vehicles:
            return Data(buttonImageName: "car",
                        name: "Vehicles",
                        emojis: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "✈️"],
                        minCountToUse: 6)

        case .zodiac:
            return Data(buttonImageName: "wand.and.stars",
                        name: "Zodiac",
                        emojis: ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"],
                        minCountToUse: 10)

        case .euFlags:
            return Data(buttonImageName: "flag",
                        name: "EU flags",
                        emojis: ["🇦🇹", "🇧🇪", "🇧🇬", "🇭🇷", "🇨🇾", "🇨🇿", "🇩🇰", "🇪🇪", "🇫🇮", "🇫🇷", "🇩🇪", "🇬🇷", "🇭🇺", "🇮🇪", "🇮🇹", "🇱🇻", "🇱🇹", "🇱🇺", "🇲🇹", "🇳🇱", "🇵🇱", "🇵🇹", "🇷🇴", "🇸🇰", "🇸🇮", "🇪🇸", "🇸🇪"],
                        minCountToUse: 8)

            /* European Union Countries
                   Austria, Belgium, Bulgaria, Croatia, Cyprus, Czech Republic,
                   Denmark, Estonia, Finland, France, Germany, Greece,
                   Hungary, Ireland, Italy, Latvia, Lithuania, Luxembourg,
                   Malta, Netherlands, Poland, Portugal, Romania, Slovakia,
                   Slovenia, Spain, Sweden
             */
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

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }

    private func createMemoryGameModel(theme: Theme) {
        let emojis = Theme.randomEmojis(from: theme)
        model = MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
        title = Theme.data(theme).name
    }

    init() {
        newGame()
    }

    // MARK: - Intent

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    func newGame() {
        createMemoryGameModel(theme: Theme.random)
    }
}