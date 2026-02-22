//
//  iExpenseBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/9.
//

import SwiftUI
import Observation

//struct UserStruct: Codable { // Codable can make sure encode and decode in order to archive and unarchive
//    let firstName: String
//    let lastName: String
//}
//
//struct iExpenseBasic: View {
//    @State private var user = UserStruct(firstName: "Kai", lastName: "Lee")
//    
//    var body: some View {
//        Button("Save user") {
//            if let data = try? JSONEncoder().encode(user) {
//                UserDefaults.standard.setValue(data, forKey: "Saved User")
//                print("Saved succeed")
//            }
//        }
//    }
//}

//struct iExpenseBasic: View {
//     // @AppStorage is more reliable than UserDefaults, as UserDefaults can not save the data in the same time, it need a few time, but AppStorage can not save complex data such as struct or class, when upload to App Store, you must explain why you use UserDefaults
////    @AppStorage(storeKey) var tapCount = 0
//    static let storeKey = "TapCount"
//    @State private var tapCount = UserDefaults.standard.integer(forKey: iExpenseBasic.storeKey)
//    var body: some View {
//        Button("Tap count \(tapCount)") {
//            tapCount += 1
//            UserDefaults.standard.setValue(tapCount, forKey: iExpenseBasic.storeKey)
//            UserDefaults.standard.synchronize() // not recommand, unless must save
//        }
//    }
//}

//struct iExpenseBasic: View {
//    @State private var rows = [Int]()
//    @State private var currentRow = 1
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                List {
//                    ForEach(rows, id:\.self) { row in
//                        Text("Row \(row)")
//                    }
//                    // onDelete only works on ForEach
//                    .onDelete(perform: deleteRows)
//                }
//
//                Button("Add row") {
//                    rows.append(currentRow)
//                    currentRow += 1
//                }
//            }
//            .navigationTitle("onDelete")
//            .toolbar {
//                EditButton()
//            }
//        }
//    }
//    
//    func deleteRows(at offsets: IndexSet) {
//        rows.remove(atOffsets: offsets)
//    }
//}

//struct SheetView: View {
//    @Environment(\.dismiss) var dismiss
//    var callBack: () -> Void
//
//    let name: String
//    var body: some View {
//        NavigationStack {
//            Text("Hello \(name)")
//                .toolbar {
//                    Button("Dismiss") {
//                        dismiss()
//                    }
//                }
//        }
//    }
//    // @escaping tell swift this block might be call in the future, use it when the closure needs to outlive the life of the function that called it
//    init(name: String, callBack: @escaping () -> Void) {
//        self.name = name
//        self.callBack = callBack
//    }
//}
//
//struct SheetStruct: Identifiable {
//    var id = UUID()
//    let name: String = "Kai"
//}
//
//struct iExpenseBasic: View {
//    @State private var isShowingSheetView = false
//    @State private var sheetStruct: SheetStruct?
//    
//    var body: some View {
//        Button("Show SheetView") {
//            isShowingSheetView.toggle()
//            sheetStruct = SheetStruct()
//        }
//        // if use optional @State, swift will auto unwrap it
//        .sheet(item: $sheetStruct, content: { sheet in
//            SheetView(name: sheet.name) {
//                print("")
//            }
//        })
////        .sheet(isPresented: $isShowingSheetView) {
////            SheetView(name: "Kai")
////        }
//    }
//}

//// all UI update are rely on @Observable rather than @State, can use right click expand macro to see what happens
//@Observable
//class User { // struct will not share data between different views, but class can and class can change property easily
//    var firstName: String = "seven"
//    var lastName: String = "Jeune"
//}
//
//struct iExpenseBasic: View {
//    //@State will observe the property changed, if change the whole body of struct will be reinvoke, swift will auto recreate a new struct, for class @State only keep them alive
//    @State private var user = User()
//
//    var body: some View {
//        VStack {
//            Text("Your name is \(user.firstName) \(user.lastName)")
//
//            // every time user type in, an instance of User(struct) will be create
//            TextField("first name: ", text:$user.firstName)
//                .textFieldStyle(.roundedBorder)
//            TextField("last name: ", text:$user.lastName)
//                .textFieldStyle(.roundedBorder)
//        }
//        .padding()
//    }
//}

class User: ObservableObject {
    @Published var firstName: String = "seven"
    @Published var lastName: String = "Jeune"
}

struct iExpenseBasic: View {
    // @StateObject tell swift make a new class instance and watch it
    @StateObject var user = User()

    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName)")

            // every time user type in, an instance of User(struct) will be create
            TextField("first name: ", text:$user.firstName)
                .textFieldStyle(.roundedBorder)
            TextField("last name: ", text:$user.lastName)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

#Preview {
    iExpenseBasic()
}
