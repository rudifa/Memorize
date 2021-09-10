//
//  ContentView.swift
//  Memorize
//
//  Created by Rudolf Farkas on 03.09.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            Text(viewModel.title)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 45))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card).aspectRatio(2 / 3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.cardColor)
            Spacer()
            Button {
                viewModel.newGame()
            } label: {
                Text("New Game")
            }
        }
        .foregroundColor(.black)
        .padding(.all)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 5.0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
