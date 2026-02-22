//
//  WordScrambleBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/9.
//

import SwiftUI

//struct WordScrambleBasic: View {
//    var body: some View {
//    }
//}

struct WordScrambleBasic: View {
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "", withExtension: "") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) {
                // we loaded the file into a string!
                
            }
        }
    }
    
    func checkSpell() {
        let input = "a b c"
        let letters = input.components(separatedBy: " ")

        let anotherInput = """
                    a
                    b
                    c
                    """
        let anotherLetters = input.components(separatedBy: "\n")

        let letter = letters.randomElement()

        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)

        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
        
        if allGood {
            print("No spell mistake")
        } else {
            print("Have spell mistake")
        }
    }
    
    var body: some View {
        VStack {}
    }
}

//struct WordScrambleBasic: View {
//    let items = [1, 2, 3, 4, 5]
//    
//    var body: some View {
//        List(items, id: \.self) { // same as foreach
//            Text(String($0))
//        }
//        .listStyle(.automatic)
//
//        List {
//            ForEach(items, id: \.self) { item in
//                Text(String(item))
//            }
//        }
//        .listStyle(.plain)
//    }
//}

//struct WordScrambleBasic: View {
//    var body: some View {
//        List(0..<5) { // List can generate data entirely from dynamic content, but Form can not
//            Text("Dynamic row \($0)")
//        }
//        .listStyle(.insetGrouped)
//    }
//}

//struct WordScrambleBasic: View {
//    var body: some View {
//        List {
//            Section("Section 1") {
//                Text("Static row 1")
//                Text("Static row 2")
//            }
//
//            Section("Section 2") {
//                ForEach(0..<5) {
//                    Text("Dynamic row \($0)")
//                }
//            }
//
//            Section("Section 3") {
//                Text("Static row 3")
//                Text("Static row 4")
//            }
//        }
//        .listStyle(.insetGrouped)
//    }
//}

#Preview {
    WordScrambleBasic()
}
