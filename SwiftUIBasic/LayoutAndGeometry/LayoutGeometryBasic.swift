//
//  LayoutGeometryBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/14.
//

import SwiftUI

/**
 SwiftUI Layout Process
 1. Parent proposes a size

 The parent view suggests a size to its child, based on its own constraints and layout rules.

 2. Child chooses its size

 The child view decides its final size within the proposed bounds.
 The parent must respect this choice.

 3. Parent positions the child

 The parent places the child in its own coordinate space.

 (Hidden step) Pixel rounding

 Although SwiftUI stores sizes and positions as floating-point values, during rendering it rounds them to the nearest pixel to keep graphics sharp.

 👉 In short: Parent proposes → Child chooses → Parent positions → SwiftUI aligns pixels.
 */

struct LayoutGeometryBasic: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { number in
                    Text("Number \(number)")
                        .font(.largeTitle)
                        .padding()
                        .background(.red)
                        .frame(width: 200, height: 200)
                        .visualEffect{ content, proxy in
                            content
                                .rotation3DEffect(
                                .degrees(-proxy.frame(in: .global).minX / 8), axis: (x: 0, y: 1, z: 0)
                                )
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                ForEach(1..<20) { number in
//                    GeometryReader { proxy in
//                        Text("Number \(number)")
//                            .font(.largeTitle)
//                            .padding()
//                            .background(.red)
//                            .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX / 8), axis: (x: 0, y: 1, z: 0)
//                            )
//                            .frame(width: 200, height: 200)
//                    }
//                    .frame(width: 200, height: 200)
//                }
//            }
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    let colors: [Color] = [
//        .red,
//        .orange,
//        .yellow,
//        .green,
//        .blue,
//        .indigo,
//        .purple
//    ]
//    
//    var body: some View {
//        GeometryReader { fullView in
//            ScrollView {
//                ForEach(0..<50) { index in
//                    GeometryReader { proxy in
//                        Text("Row #\(index)")
//                            .font(.title)
//                            .frame(maxWidth: .infinity)
//                            .background(colors[index % 7])
//                            .rotation3DEffect(
//                                .degrees(
//                                    proxy.frame(in: .global).minY - fullView.size.height / 2) / 5,
//                                axis: (x: 0, y: 1, z: 0)
//                            )
//                    }
//                    .frame(height: 40)
//                }
//            }
//        }
//    }
//}

//struct OuterView: View {
//    var body: some View {
//        VStack {
//            Text("Top")
//
//            InnerView()
//                .background(.green)
//
//            Text("Bottom")
//        }
//    }
//}
//
//struct InnerView: View {
//    var body: some View {
//        HStack {
//            Text("Left")
//
//            GeometryReader { proxy in
//                Text("Center")
//                    .background(.blue)
//                    .onTapGesture {
//                        print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
//                        print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
//                        print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
//                    }
//            }
//            .background(.orange)
//
//            Text("Right")
//        }
//    }
//}
//
//struct LayoutGeometryBasic: View {
//    var body: some View {
//        OuterView()
//            .background(.red)
//            .coordinateSpace(name: "Custom")
//        
//        VStack {
//            GeometryReader { proxy in
//                Text("Hello, world!")
//                    .frame(width: proxy.size.width * 0.9)
//                    .background(.red)
//            }
//            .background(.green)
//
//            Text("More text")
//                .background(.blue)
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        HStack {
//            Text("Po")
//                .frame(width: 200)
//                .background(.blue)
//            GeometryReader { proxy in
//                Image(.example)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: proxy.size.width * 0.8)
//                    .frame(width: proxy.size.width, height: proxy.size.height)
////                    .containerRelativeFrame(.horizontal) { size, axis in
////                        size * 0.8
////                    }
//            }
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        GeometryReader { proxy in
//            Image(.example)
//                .resizable()
//                .scaledToFit()
//                .frame(width: proxy.size.width * 0.8)
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        Text("Hello, world!")
//            .background(.blue)
//            // changing the location where a view should be rendered without actually changing its underlying geometry
//            .offset(x:100 , y:100)
//            .background(.red)
//        
//        // Absolute positioning
////            .background(.blue)
////            .position(x:100, y: 100)
////            .background(.red)
//    }
//}

//extension VerticalAlignment {
//    enum MidAccountAndName: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[.top]
//        }
//    }
//
//    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
//}
//
//struct LayoutGeometryBasic: View {
//    var body: some View {
//        HStack(alignment: .midAccountAndName) {
//            VStack {
//                Text("Hello")
//                    .alignmentGuide(.midAccountAndName) { d in
//                        d[VerticalAlignment.center]
//                    }
//
//                Image(systemName: "globe")
//                    .resizable()
//                    .frame(width: 64, height: 64)
//            }
//
//            VStack {
//                Text("World")
//                Text("Hi")
//                    .alignmentGuide(.midAccountAndName) { d in
//                        d[VerticalAlignment.center]
//                    }
//                    .font(.largeTitle)
//            }
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            ForEach(0..<10) { position in
//                Text("Number \(position)")
//                    .alignmentGuide(.leading) { _ in
//                        Double(position) * -10
//                    }
//            }
//        }
//        .background(.red)
//        .frame(width: 400, height: 400)
//        .background(.blue)
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Hello, world!")
//                .alignmentGuide(.leading) { d in
//                    d[.trailing]
//                }
//            Text("This is a longer line of text")
//        }
//        .background(.red)
//        .frame(width: 400, height: 400)
//        .background(.blue)
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        HStack(alignment: .lastTextBaseline) {
//            Text("Live")
//                .font(.caption)
//
//            Text("Long")
//
//            Text("and")
//                .font(.title)
//
//            Text("prospect")
//                .font(.largeTitle)
//        }
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        Text("This is a longer line of text")
//            .frame(width: 300, height: 300, alignment: .topLeading)
//    }
//}

//struct LayoutGeometryBasic: View {
//    var body: some View {
//        Text("Hello, world!")
//            .padding(20) // add modifier makes new views rather than an existing view
//            .background(.red) // background is layout neutral like contentView(LayoutGeometryBasic), other layout neutral(shape, color)
//    }
//}

#Preview {
    LayoutGeometryBasic()
}
