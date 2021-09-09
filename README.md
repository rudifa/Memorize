# Learning SwiftUI
#### from Professor Paul Hegarty, Stanford University CS193p Spring 2021 course

#### *[Lesson 1: Getting started with SwiftUI](https://www.youtube.com/watch?v=bqu6BquVi2M)*

Introduces the Xcode and creates an initial SwiftUI application


```
import SwiftUI
@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Highlights a hiearchy of [`View`](https://docs.google.com/document/d/1BaqqU2GpQ1I8GkcWZbuTvmBFB5qRDIYlkclxkcjUuKc/edit) instances consisting of containers like `ZStack` and final views like `Text`.

A container view takes an argument, an `@ViewBuilder` function that returns `some View`. This function must list one or more views, and can have local variables and if-then constructs, to control the layout of the contained views. 

Adds modifier views like `.padding` and `.foregroundColor`.

```
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

```

#### *[Lesson 2: Learning more about SwiftUI](https://www.youtube.com/watch?v=3lahkdHEhW8)*

Factors out code into a subview, `struct CardView: View`.

Introduces a local variable, `@State var isFaceUp: Bool` and a gesture modifier `.onTapGesture { isFaceUp.toggle() }`.

Puts to the use more container (or combiner) views: `VStack`, `HStack``LazyVGrid`, `ForEach`, `ScrollView`, and uses final views like `Button` and `Spacer`.

Shows how to make the card size and shape adapt to different screen sizes and orientations with `GridItem(.adaptive(minimum: 65))` and `.aspectRatio(2 / 3, contentMode: .fit)`.

#### *[Lesson 3: MVVM and the Swift type system](https://www.youtube.com/watch?v=--qKOhdgJAs)*

Explains the MVVM architecture in general terms

![MVVM](https://cs193p.sites.stanford.edu/sites/g/files/sbiybj16636/files/styles/card_1900x950/public/media/image/l3_still_small_0.png?h=32a8b475&itok=vFDFi6rz)

View depends on ViewModel and it

* subscribes to notifications from ViewModel
* reads the Model data to be displayed, as interpreted by ViewModel
* calls 'intent' functions on ViewModel to modify the Model data

ViewModel depends on Model and it

* reads the Model data
* modifies the Model data

The demo project introduces the Model `struct MemoryGame` and the ViewModel `class EmojiMemoryGame`.

#### *Lesson 4: Memorize Game Logic*

At the end of this lesson the Model, ViewModel and the View look like this:

```
import Foundation

// MARK: - Model

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]

    private var indexOfOneAndOnlyFaceUpCard: Int?

    // the game logic
    mutating func choose(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFaceUp,
           !cards[index].isMatched
        {
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[index].content == cards[potentialMatchIndex].content {
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isFaceUp.toggle()
        }
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
}

```

The Model is generic in `CardContent`.


```
import SwiftUI

// MARK: - ViewModel

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
```

The ViewModel defines a specific `CardContent`, a `String` containining an emoji character. A possible alternative could be an `Image`.

The ViewModel is declared as `ObservableObject` and its data member `var model` is `@Published`, meaning that it notifies subscribers of any change in the model.

```
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card).aspectRatio(2 / 3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.red)
        .padding(.all)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    var body: some View {
    ...
    }
}
```

The View subscribes to the notifications of Model changes by declaring `@ObservedObject var viewModel: EmojiMemoryGame`. 

Consequently, the View will rebuild the view hierarchy on the screen whenever the Model state changes.

On user event, `.onTapGesture { viewModel.choose(card) }` causes the ViewModel to update the Model state.


```
import SwiftUI

@main
struct MemorizeApp: App {
    var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
```

The App binds the elements together, by creating the instance `var game = EmojiMemoryGame()` and passing it to the main view in `ContentView(viewModel: game)`.

Thus, the View owns (and depends on) ViewModel, and ViewModel owns (and depends on) Model, as suggested in the above presentation of MVVM.



#### *[Lesson 5: Properties Layout @ViewBuilder](https://www.youtube.com/watch?v=--qKOhdgJAs)*

More about `@State` variables:

* used to store temporary state local to the view
* view rebuilds its body when the variables change

The demo code gets cleaned up and simplified using Swift functional programming and other features.

How is the space on-screen apportioned to the Views?

1. Container Views offer space to the contained Views
2. Views choose the size they want
3. Container Views position the contained Views
4. Container Views choose their own size based on (2)

`HStack` and `VStack` offer the space to the least flexible subviews first.

Examples:

* Image: very inflexible (fixed size)
* Text: more flexible
* RoundedRectangle: very flexible (uses all of the space offered)

`Text("xyz").layoutPriority(100)` will override the default priority/flexibility which is 0.

`HStack` and `VStack` have the `alignment` parameter: `.center`, `.leading`, ...

`LazyHStack` and `LazyVStack` do not build views that are not on the screen, so they are used inside `ScrollView`.

`LazyHGrid` and `LazyVGrid` ... tbd

`List`, `Form` and `OutlineGroup` ... tbd

`HStack`, `VStack` and `ZStack` become fully flexible if they contain at least one fully flexible subview.

Modifiers `.background `and `.overlay` add another `View` behind or in front of the `View` they are applied to.

`GeometryReader` supplies to its subviews a `GeometryProxy` object that contains the `.size` which can be used by the subviews to adapt their size properties (e.g. `fontSize`) to the size offered. This is shown in the demo.

Wrapper `@ViewBuilder` can be applied to a function or a computed variable that returns `some View`. Consequently, the function body behaves like the var body of a `View`, namely it can contain a list of `View`s and possibly local variables and if-let constructs.

This opens the way to writing custom container views and modifiers.

#### *[Lesson 6: Protocols Shapes](https://www.youtube.com/watch?v=Og9gXZpbKWo)*

The lecturer explains in detail the features of Swift Generics and Protocols, and hints at how these are used in SwiftUI.

In the demo, he creates a custom View combiner `AspectVGrid` that will display all game cards in a grid, adapting the card size to the available screen space.

`AspectVGrid` is used like this:

```
struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2 / 3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card)
                    .padding(2)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.all)
    }
}

```

Important notes on `AspectVGrid`:

- it is generic in `<Item, ItemView>` 
- the generic result `ItemView` must be a `View`
- the generic input `Item` must be `Identifiable`
- it has an eplicit `init(...)` with 3 parameters
- the parameter `content` is a closure that is stored in a var, so it must be annotated as `@escaping`
- the parameter `content` is also anotated as `@ViewBuilder`, so its body can accept several `View`s, variables and if-else constructs

```
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }

    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }

    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + columnCount - 1) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

```

In the second demo a custom pie chart shape, `Pie`, is created. 

`Shape` is a protocol that inherits from `View`. One of its features is the function `.fill(...)`, already seen in the demo. Interestingly, its argument is not a simple color, but a `ShapeStyle` which can also be  an image or a gradient:

`func fill<S>(_ whatToFillWith: S9 -> some View where S: ShapeStyle`


The finished `Pie` shape looks like this:

```
struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: center)
        return p
    }
}
```

Notes:

- the view conforming to the `Shape` protocol must implement `func path(in rect: CGRect) -> Path`
- the implementation uses the `Path` functions to draw the desired shape in the supplied `rect`.


At the end of the Lesson 6 demo a `Pie` is inserted into the `CardView`'s `ZStack`:


```
struct CardView: View {
...
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Const.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: Const.lineWidth)
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 110-90)).padding(5).opacity(0.4)
                    Text(card.content).font(font(of: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
...
}
```


#### *[Lesson 7: ViewModifier Animation](https://www.youtube.com/watch?v=PoeaUMGAx6c)*

Animations in SwiftUI are always done in view modifiers or in shapes.

The SwiftUI `View` has a function, [`.modifier(_:)`](https://developer.apple.com/documentation/swiftui/view/modifier(_:)) which takes anything conforming to the `protocol ViewModifier`.

```
protocol ViewModifier {
    typealias Content
    func body(content: Content) -> some View {
        return ... // some view that 
        almost certainly contains the View content
```

As an example, the Lesson 7 Demo (final version) defines

```
struct Cardify: ViewModifier {
    var isFaceUp: Bool

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Const.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Const.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(isFaceUp ? 1 : 0)
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
```

and uses it in `struct CardView`

```
var body: some View {
    GeometryReader { geometry in
        ZStack {
            Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 110 - 90)).padding(5).opacity(0.4)
            Text(card.content).font(font(of: geometry.size))
        }
        .cardify(isFaceUp: card.isFaceUp)
    }
}
```

There are three ways to animate

* implicit: `.animation(Animation)` view modifier
* explicit: `withAnimation(.linear(duration: 2)) {...}`
* xxx

Demo of implicit animation (rotates `card.content` when `card.isMatched `changes)

```
struct CardView: View {
...
	Text(card.content)
	    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
	    .animation(.easeInOut(duration: 2))
	    .font(Font.system(size: Const.fontSize))
	    .scaleEffect(scale(thatFits: geometry.size))
...
}

private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (Const.fontSize / Const.fontScale)
}

```

#### See also

[MVVM in iOS with SwiftUI (Detailed Example + Pitfalls)](https://matteomanferdini.com/mvvm-pattern-ios-swift/)
