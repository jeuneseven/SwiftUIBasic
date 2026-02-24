//
//  Sheets.swift
//  SwiftUIBasic
//
//  Sheet, fullScreenCover, and presentation examples
//

import SwiftUI

// MARK: - Basic Sheet

struct BasicSheetExample: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            Text("This is a sheet!")
                .presentationDetents([.medium, .large])
        }
    }
}

// MARK: - Sheet with Dismiss

struct SheetContentView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Hello, \(name)!")
                    .font(.title)
                
                Button("Close") {
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SheetWithDismissExample: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            SheetContentView(name: "Swift")
        }
    }
}

// MARK: - Sheet with Callback

struct SheetWithCallbackExample: View {
    @State private var showingSheet = false
    @State private var message = "No message yet"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(message)
            
            Button("Show Sheet") {
                showingSheet = true
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: {
            message = "Sheet was dismissed!"
        }) {
            Text("Dismiss me to see the callback")
                .presentationDetents([.medium])
        }
    }
}

// MARK: - Sheet with Optional Item (Identifiable)

struct SheetItem: Identifiable {
    var id = UUID()
    var title: String
    var description: String
}

struct SheetWithItemExample: View {
    @State private var selectedItem: SheetItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Item A") {
                selectedItem = SheetItem(title: "Item A", description: "This is item A")
            }
            
            Button("Show Item B") {
                selectedItem = SheetItem(title: "Item B", description: "This is item B")
            }
        }
        // Swift will auto unwrap the optional
        .sheet(item: $selectedItem) { item in
            VStack(spacing: 20) {
                Text(item.title)
                    .font(.title)
                Text(item.description)
            }
            .presentationDetents([.medium])
        }
    }
}

// MARK: - Presentation Detents (Sheet Heights)

struct PresentationDetentsExample: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            VStack {
                Text("Drag to resize")
                    .font(.headline)
                Text("This sheet supports multiple heights")
            }
            .presentationDetents([.height(200), .medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Full Screen Cover

struct FullScreenCoverExample: View {
    @State private var showingCover = false
    
    var body: some View {
        Button("Show Full Screen") {
            showingCover = true
        }
        .fullScreenCover(isPresented: $showingCover) {
            NavigationStack {
                VStack {
                    Text("Full Screen Content")
                        .font(.title)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue.opacity(0.2))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            showingCover = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Interactive Dismiss Prevention

struct InteractiveDismissExample: View {
    @State private var showingSheet = false
    @State private var text = ""
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            NavigationStack {
                Form {
                    TextField("Enter something", text: $text)
                }
                .navigationTitle("Edit")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showingSheet = false
                        }
                    }
                }
            }
            // Prevent dismiss when text is not empty
            .interactiveDismissDisabled(!text.isEmpty)
        }
    }
}

// MARK: - Preview

#Preview("Basic Sheet") {
    BasicSheetExample()
}

#Preview("Sheet with Dismiss") {
    SheetWithDismissExample()
}

#Preview("Sheet with Callback") {
    SheetWithCallbackExample()
}

#Preview("Sheet with Item") {
    SheetWithItemExample()
}

#Preview("Presentation Detents") {
    PresentationDetentsExample()
}

#Preview("Full Screen Cover") {
    FullScreenCoverExample()
}

#Preview("Interactive Dismiss") {
    InteractiveDismissExample()
}
