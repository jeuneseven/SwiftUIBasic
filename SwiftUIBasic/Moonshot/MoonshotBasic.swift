//
//  MoonshotBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/10.
//

import SwiftUI

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd"
        return df
    }()
}

extension Bundle {
    // <T> is generics, <> also called Pulp Fiction brackets, T is stand for some type
    func decoder<T: Codable>(_ file: String) -> T {
        guard let loadFile = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to load file \(file)")
        }
        
        guard let data = try? Data(contentsOf: loadFile) else {
            fatalError("Failed to load data in file \(file)")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateFormatter)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

//struct MoonshotBasic: View {
//    let layout = [
//        GridItem(.fixed(80)), // 80 is width
//        GridItem(.fixed(80)),
//        GridItem(.fixed(80))
//    ]
//    
//    let adaptLayout = [
//        GridItem(.adaptive(minimum: 50, maximum: 120))
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal) {
//                LazyHGrid(rows: adaptLayout) {
//                    ForEach(0..<100) {
//                        Text("Item \($0)")
//                    }
//                }
//            }
//            
//            ScrollView {
//                LazyVGrid(columns: layout) {
//                    ForEach(0..<100) {
//                        Text("Item \($0)")
//                    }
//                }
//            }
//        }
//    }
//}

//struct JSONObject: Codable {
//    var navigationBarTitleText: String
//    var usingComponents: UsingComponents
//}
//
//struct UsingComponents: Codable {
//    var i_icon: String
//}
//
//struct MoonshotBasic: View {
//    var body: some View {
//        Button("Decode JSON") {
//            let input = """
//            {
//              "navigationBarTitleText": "title",
//              "usingComponents":{
//                "i_icon":"/iview/icon/index"
//              }
//            }
//            """
//            let data = Data(input.utf8)
//            let decoder = JSONDecoder()
//            if let object = try? decoder.decode(JSONObject.self, from: data) {
//                // /iview/icon/index
//                print(object.usingComponents.i_icon)
//            }
//        }
//    }
//}

//struct MoonshotBasic: View {
//    var body: some View {
//        NavigationStack {
//            List(0..<100) { row in
//                NavigationLink("Row \(row)") { // NavigationLink can make sure the gray indicator in order to push to another view
//                    Text("Detail \(row)")
//                }
//
////                NavigationLink {
////                    Text("Detail \(row)")
////                } label: {
////                    Text("Row \(row)")
////                }
//            }
//            .navigationTitle("SwiftUI")
//            
//            NavigationLink {
//                Text("Detail View")
//                    .navigationTitle("DetailView")
//            } label: {
//                Text("Tap me")
//            }
//            .navigationTitle("SwiftUI")
//        }
//    }
//}

//struct CustomText: View {
//    var text:String
//
//    var body: some View {
//        Text(text)
//    }
//
//    init(_ text: String) {
//        print("a CustomText is created: \(text)")
//        self.text = text
//    }
//}
//
//struct MoonshotBasic: View {
//    var body: some View {
//        ScrollView(.vertical) { // make sure vertical -> LazyVStack
//            LazyVStack { // VStack will create CustomText all in it create, LazyVStack not and it will always take up as much space as avaliable in layouts, don't need .frame(maxWidth: .infinity)
//                ForEach(0..<100) {
//                    CustomText("Row \($0)")
//                        .font(.title)
//                }
//            }
////            .frame(maxWidth: .infinity)
//        }
//    }
//}

//struct MoonshotBasic: View {
//    var body: some View {
//        Image(.example)
//            .resizable()
//            .scaledToFit()
//            // size is the actual measured size of parent view
//            .containerRelativeFrame([.horizontal, .vertical]) { size, axis in
//                if axis == .vertical {
//                    size
//                } else {
//                    size * 0.7
//                }
//            }
//        
////            .scaledToFit() // make sure the entire image fits inside its frame even the view has some empty at the edge
////            .scaledToFill() // fill the picture even if some parts hanging out
////            .frame(width: 300, height: 200)
//    }
//}

struct MoonshotBasic: View {
    var body: some View {
        GeometryReader { geo in
            Image(.example)
                .resizable()
                .scaledToFit()
                .frame(width: geo.size.width * 0.8)
                .frame(width: geo.size.width, height: geo.size.height) // make it center
        }
    }
}

#Preview {
    MoonshotBasic()
}
