//
//  SnowSeekerBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/14.
//

import SwiftUI
import Observation

//struct SnowSeekerBasic: View {
//    var body: some View {
//        NavigationSplitView(columnVisibility: .constant(.all)) {
//            NavigationLink("Tap me") {
//                Text("Detail View")
//            }
//        } detail: {
//            Text("Content View")
//        }
//        .navigationSplitViewStyle(.balanced)
//    }
//}

//struct UserClassModel: Identifiable {
//    var id = "Swift"
//}
//
//struct SnowSeekerBasic: View {
//    @State private var selectedUser: UserClassModel? = nil
//    @State private var isShowingUser = false
//    
//    var body: some View {
//        Button("Tap me") {
//            selectedUser = UserClassModel()
//            isShowingUser = true
//        }
//        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
//            Button(user.id) {
//
//            }
//        }
//        .sheet(item: $selectedUser) { user in
//            Text(user.id)
//                .presentationDetents([.medium, .large])
//        }
//    }
//}

//struct Layout: View {
//    var body: some View {
//        Group {
//            Text("A")
//            Text("B")
//            Text("C")
//        }
//    }
//}
//
//struct SnowSeekerBasic: View {
//    @State private var isLayoutVertically = false
//    
//    var body: some View {
//        Button {
//            isLayoutVertically.toggle()
//        } label: {
//            if isLayoutVertically {
//                VStack {
//                    Layout()
//                }
//            } else {
//                HStack {
//                    Layout()
//                }
//            }
//        }
//    }
//}
//
//struct SnowSeekerBasic: View {
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    
//    var body: some View {
//        if horizontalSizeClass == .regular {
//            VStack(content: Layout.init)
//        } else {
//            HStack(content: Layout.init)
//        }
//    }
//}

//struct SnowSeekerBasic: View {
//    var body: some View {
//        ViewThatFits {
//            Rectangle()
//                .frame(width: 450, height: 200)
//                .foregroundStyle(.primary)
//
//            Circle()
//                .frame(width: 200, height: 200)
//                .foregroundStyle(.primary)
//        }
//    }
//}

//struct SnowSeekerBasic: View {
//    @State private var searchText = ""
//    let options = ["A", "B", "C", "D"]
//    var filterOptions: [String] {
//        if searchText.isEmpty {
//            options
//        } else {
//            options.filter { option in
//                option.localizedStandardContains(searchText)
//            }
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            List(filterOptions, id: \.self) {
//                Text($0)
//            }
//            .navigationTitle("Search")
//            .searchable(text: $searchText, prompt: "Search")
//        }
//    }
//}

@Observable
class Player {
    var name = "Swift"
    var highScore = 0
}

struct HighScoreView: View {
    @Environment(Player.self) var player
    var body: some View {
        //  make a copy of my player property locally then wrap it in some bindings I can use
        @Bindable var player = player
        Stepper("Your highscore is", value: $player.highScore, in: 1...10)
        Text("\(player.highScore)")
    }
}

struct SnowSeekerBasic: View {
    @State private var player = Player()
    
    var body: some View {
        VStack {
            HighScoreView()
        }
        .environment(player)
    }
}

#Preview {
    SnowSeekerBasic()
}
