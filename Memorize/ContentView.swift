//
//  ContentView.swift
//  Memorize
//
//  Created by Rudolf Farkas on 03.09.21.
//

import SwiftUI

enum Theme {
    case vehicles
    case zodiac
    case euFlags

    struct Data {
        let buttonImageName: String
        let buttonText: String
        let emojis: [String]
    }

    static func data(_ selected: Theme) -> Data {
        switch selected {
        case .vehicles:
            return Data(buttonImageName: "car",
                        buttonText: "Vehicles",
                        emojis: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🦽", "🚲", "🛵", "🏍", "🛺", "🚞", "🚝", "✈️"])

        case .zodiac:
            return Data(buttonImageName: "wand.and.stars",
                        buttonText: "Zodiac",
                        emojis: ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"])

        case .euFlags:
            return Data(buttonImageName: "flag",
                        buttonText: "EU flags",
                        emojis: ["🇦🇹", "🇧🇪", "🇧🇬", "🇭🇷", "🇨🇾", "🇨🇿", "🇩🇰", "🇪🇪", "🇫🇮", "🇫🇷", "🇩🇪", "🇬🇷", "🇭🇺", "🇮🇪", "🇮🇹", "🇱🇻", "🇱🇹", "🇱🇺", "🇲🇹", "🇳🇱", "🇵🇱", "🇵🇹", "🇷🇴", "🇸🇰", "🇸🇮", "🇪🇸", "🇸🇪"])

            /* European Union Countries
                   Austria, Belgium, Bulgaria, Croatia, Cyprus, Czech Republic,
                   Denmark, Estonia, Finland, France, Germany, Greece,
                   Hungary, Ireland, Italy, Latvia, Lithuania, Luxembourg,
                   Malta, Netherlands, Poland, Portugal, Romania, Slovakia,
                   Slovenia, Spain, Sweden
             */
        }
    }
}

struct ContentView: View {
    @State var selected = Theme.vehicles

    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                let emojis = Theme.data(selected).emojis.shuffled()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis, id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2 / 3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            HStack {
                themeButton(for: .vehicles)
                Spacer()
                themeButton(for: .zodiac)
                Spacer()
                themeButton(for: .euFlags)
            }
            .font(.largeTitle)
            .padding([.top, .leading, .trailing])
        }
        .padding(.all)
    }

    private func themeButton(for theme: Theme) -> some View {
        VStack {
            let data = Theme.data(theme)
            Button(action: { selected = theme }, label: {
                VStack {
                    Image(systemName: data.buttonImageName)
                    Text(data.buttonText).font(.headline)
                }
            })
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    let shape = RoundedRectangle(cornerRadius: 25.0)
    var body: some View {
        ZStack {
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
