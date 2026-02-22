//
//  ViewsAndModifiersBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/9.
//

import SwiftUI

struct Watermark: ViewModifier {
    var text: String // custom view modifier can has their own property

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View { // extension a view can not have their own property
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct ViewsAndModifiersBasic: View {
    var body: some View {
        Color.blue
            .frame(width: 300, height: 200)
            .watermarked(with: "Swift")
    }
}

//struct Title: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.largeTitle)
//            .foregroundStyle(.white)
//            .padding()
//            .background(.blue)
//            .clipShape(.rect(cornerRadius: 10))
//    }
//}
//
//extension View {
//    func titleStyle() -> some View {
//        modifier(Title())
//    }
//}
//
//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        // custom modifier
//        Text("Hello World")
//            .modifier(Title())
////            .titleStyle()
//    }
//}

//struct CapsuleText: View {
//    var text: String
//
//    var body: some View {
//        Text(text)
//            .font(.largeTitle)
//            .padding()
//            .foregroundStyle(.white)
//            .background(.blue)
//            .clipShape(.capsule)
//    }
//}
//
//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        VStack(spacing: 10) {
//            CapsuleText(text: "First")
//                .blur(radius: 2)
//            CapsuleText(text: "Second")
//                .foregroundStyle(.blue) // not working
//                .background(.black) // rectangle black
//        }
//    }
//}

//struct ViewsAndModifiersBasic: View { // three way to use views as proproty
//    // 1. computed property
//    var motto1: some View {
//        Text("Draco dormiens")
//    }
//
//    let motto2 = Text("nunquam titillandus")
//    // 2. Group
//    var spells: some View {
//        Group {
//            Text("Lumos")
//            Text("Obliviate")
//        }
//    }
//    // 3. @ViewBuilder
//    @ViewBuilder var anotherSpells: some View {
//        Text("Lumos")
//        Text("Obliviate")
//    }
//    
//    var body: some View {
//        VStack {
//            motto1
//                .foregroundStyle(.red)
//            motto2
//                .foregroundStyle(.blue)
//        }
//        HStack {
//            spells
//        }
//        ZStack {
//            anotherSpells
//        }
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        VStack {
//            Text("Gryffindor")
//                .blur(radius: 0) // That won’t work the same way: blur() is a regular modifier, so any blurs applied to child views are added to the VStack blur rather than replacing it.
//
//            Text("Hufflepuff")
//            Text("Ravenclaw")
//            Text("Slytherin")
//        }
//        .blur(radius: 5)
//        .font(.title)
//
//        VStack {
//            Text("Gryffindor")
//                .font(.largeTitle) // will overwrite the VStack.font which is an envirement modifer
//
//            Text("Hufflepuff")
//            Text("Ravenclaw")
//            Text("Slytherin")
//        }
//        .font(.title)
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    @State private var useRedText = false
//    @State private var useBlackText = false
//    
//    var body: some View {
//        // need to destroy different view
//        if useRedText {
//            Button("Hello World") {
//                useRedText.toggle()
//            }
//            .foregroundStyle(.red)
//        } else {
//            Button("Hello World") {
//                useRedText.toggle()
//            }
//            .foregroundStyle(.blue)
//        }
//        // perfer use turn operation conditional
//        Button("Hello World!") {
//            useBlackText.toggle()
//        }
//        .foregroundStyle(useBlackText ? .red : .blue)
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        // swift use a @ViewBuilder to wrap these two text as a tuple view container
//        Text("a")
//        Text("b")
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        // render padding and background color times can be overlay, consider view modifier is rerender the view each time
//        Text("Hello, world!")
//            .padding()
//            .background(.red)
//            .padding()
//            .background(.blue)
//            .padding()
//            .background(.green)
//            .padding()
//            .background(.yellow)
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        Button("Hello, world!") {
//            // AnyView
//            print(type(of: self.body))
//        }
//        // view modifier's order matters
////        .frame(width: 200, height: 200)
//        .background(.red)
//        .frame(width: 300, height: 300)
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        // infinity means make this view occupy available space
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.red)
//    }
//}

//struct ViewsAndModifiersBasic: View {
//    var body: some View {
//        // there is an UIHostingController behind the view, it's belong to UIKit, it is the bridge of UIKit and SwiftUI framework
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//        .background(.red)
//    }
//}

#Preview {
    ViewsAndModifiersBasic()
}
