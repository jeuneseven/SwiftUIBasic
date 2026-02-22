//
//  SwiftUIBasicApp.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/8.
//

import SwiftUI
import SwiftData

@main // tell swift we launch app from here
struct SwiftUIBasicApp: App {
    var body: some Scene {
        WindowGroup { // tell swift support multiple windows
            HotProspectsBasic()
//                .modelContainer(for: [StudentModel.self])
        }
    }
}
