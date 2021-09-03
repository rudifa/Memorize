//
//  ContentView.swift
//  Memorize
//
//  Created by Rudolf Farkas on 03.09.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke()
            Text("Hello, world!")
        }
        .padding(.all)
        .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
