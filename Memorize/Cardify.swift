//
//  Cardify.swift
//  Memorize
//
//  Created by Rudolf Farkas on 07.09.21.
//

import SwiftUI

// a view modifier that wraps the supplied view in a card

struct Cardify: ViewModifier {
    var isFaceUp: Bool

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Const.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Const.lineWidth)
                content
            } else {
                shape.fill()
            }
        }
    }

    private enum Const {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
