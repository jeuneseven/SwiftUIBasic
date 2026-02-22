//
//  BookwormBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/12.
//

import SwiftUI
import SwiftData

@Model // @Model macro built on the same observation system used by the @Observable macro
class StudentModel {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

struct BookwormBasic: View {
    @Environment(\.modelContext) var modelContext
    @Query var students: [StudentModel]
    
    var body: some View {
        NavigationStack {
            List(students) { student in
                Text(student.name)
            }
            .navigationTitle("Classroom")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    let firstName = ["A", "B", "C", "D"]
                    let lastName = ["a", "b", "c", "d"]
                    
                    let choosenFirstName = firstName.randomElement()!
                    let choosenLastName = lastName.randomElement()!
                    
                    let student = StudentModel(id: UUID(), name: "\(choosenFirstName) \(choosenLastName)")
                    
                    modelContext.insert(student)
                    try? modelContext.save()
                }
            }
        }
    }
}

//struct BookwormBasic: View {
//    @AppStorage("AppNotes") private var notes = ""
//    
//    var body: some View {
//        NavigationStack {
//            Form {
////                TextEditor(text: $notes)
//
//                TextField("Enter text", text: $notes, axis: .vertical)
////                    .textFieldStyle(.roundedBorder)
////                    .padding()
//            }
//            .navigationTitle("Notes")
//        }
//    }
//}

/**
 @Bindable create missing binding for @Observable class without @state to create local data
 @Binding share a simple @state property belong to one view with another view
 */
//struct ToggleButton: View {
//    let title: String
//    @Binding var isOn: Bool
//
//    let onColors = [Color.red, Color.yellow]
//    let offColors = [Color.black, Color.blue]
//
//    var body: some View {
//        Button(title) {
//            isOn.toggle()
//        }
//        .padding()
//        .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
//        .foregroundStyle(.white)
//        .clipShape(.capsule)
//        .shadow(radius: isOn ? 5 : 0)
//    }
//}
//
//struct BookwormBasic: View {
//    @State private var toggle = false
//    
//    var body: some View {
//        VStack {
//            ToggleButton(title: "Toggle", isOn: $toggle)
//            Text(toggle ? "on" : "off")
//        }
//    }
//}

#Preview {
    BookwormBasic()
}
