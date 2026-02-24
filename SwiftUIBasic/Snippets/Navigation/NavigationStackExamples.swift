//
//  NavigationStack.swift
//  SwiftUIBasic
//
//  NavigationStack, NavigationLink, and toolbar basics
//

import SwiftUI

// MARK: - Basic NavigationStack

struct BasicNavigationStackExample: View {
    var body: some View {
        NavigationStack {
            List(0..<10) { index in
                NavigationLink("Row \(index)") {
                    Text("Detail View \(index)")
                        .navigationTitle("Detail")
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - NavigationLink with Custom Label

struct NavigationLinkCustomLabelExample: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Text("Settings Detail")
                } label: {
                    Label("Settings", systemImage: "gear")
                }
                
                NavigationLink {
                    Text("Profile Detail")
                } label: {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("View Profile")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

// MARK: - Title Display Modes

struct TitleDisplayModesExample: View {
    var body: some View {
        TabView {
            NavigationStack {
                List(0..<20) { Text("Row \($0)") }
                    .navigationTitle("Large Title")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Large", systemImage: "textformat.size.larger") }
            
            NavigationStack {
                List(0..<20) { Text("Row \($0)") }
                    .navigationTitle("Inline Title")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Inline", systemImage: "textformat.size.smaller") }
        }
    }
}

// MARK: - Editable Navigation Title

struct EditableNavigationTitleExample: View {
    @State private var title = "My Document"
    
    var body: some View {
        NavigationStack {
            Text("Content goes here")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Editable title - user can tap to edit
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Toolbar Basics

struct ToolbarBasicsExample: View {
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            List(0..<10) { index in
                Text("Item \(index)")
            }
            .navigationTitle("Toolbar Demo")
            .toolbar {
                // Single button - trailing by default
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        print("Add tapped")
                    }
                }
                
                // Leading placement
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Toolbar Item Group

struct ToolbarItemGroupExample: View {
    var body: some View {
        NavigationStack {
            Text("Content")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Actions")
                .toolbar {
                    // Group multiple items in same placement
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("Share", systemImage: "square.and.arrow.up") {
                            print("Share tapped")
                        }
                        
                        Button("Favorite", systemImage: "heart") {
                            print("Favorite tapped")
                        }
                        
                        Button("More", systemImage: "ellipsis.circle") {
                            print("More tapped")
                        }
                    }
                }
        }
    }
}

// MARK: - Toolbar with Menu

struct ToolbarWithMenuExample: View {
    @State private var sortOrder = "Name"
    
    var body: some View {
        NavigationStack {
            List {
                Text("Sorted by: \(sortOrder)")
            }
            .navigationTitle("Files")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Name") { sortOrder = "Name" }
                        Button("Date") { sortOrder = "Date" }
                        Button("Size") { sortOrder = "Size" }
                        
                        Divider()
                        
                        Button("Delete All", role: .destructive) {
                            print("Delete all")
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
}

// MARK: - Hide Back Button

struct HideBackButtonExample: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Go to Detail") {
                VStack(spacing: 20) {
                    Text("Detail View")
                        .font(.title)
                    
                    Text("Back button is hidden. Use the button below to go back.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .navigationTitle("Detail")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            // Custom back action
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            // Save action
                        }
                    }
                }
            }
            .navigationTitle("Main")
        }
    }
}

// MARK: - Toolbar Visibility

struct ToolbarVisibilityExample: View {
    @State private var hideToolbar = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Hide Navigation Bar", isOn: $hideToolbar)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Visibility")
            .toolbar(hideToolbar ? .hidden : .visible, for: .navigationBar)
        }
    }
}

// MARK: - Toolbar Background

struct ToolbarBackgroundExample: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<30) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .navigationTitle("Custom Toolbar")
            .toolbarBackground(.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Bottom Toolbar

struct BottomToolbarExample: View {
    var body: some View {
        NavigationStack {
            Text("Content Area")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Editor")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Bold", systemImage: "bold") {}
                        Button("Italic", systemImage: "italic") {}
                        Button("Underline", systemImage: "underline") {}
                        
                        Spacer()
                        
                        Button("Done") {}
                    }
                }
        }
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicNavigationStackExample()
}

#Preview("Custom Label") {
    NavigationLinkCustomLabelExample()
}

#Preview("Title Display Modes") {
    TitleDisplayModesExample()
}

#Preview("Editable Title") {
    EditableNavigationTitleExample()
}

#Preview("Toolbar Basics") {
    ToolbarBasicsExample()
}

#Preview("Toolbar Item Group") {
    ToolbarItemGroupExample()
}

#Preview("Toolbar Menu") {
    ToolbarWithMenuExample()
}

#Preview("Hide Back Button") {
    HideBackButtonExample()
}

#Preview("Toolbar Visibility") {
    ToolbarVisibilityExample()
}

#Preview("Toolbar Background") {
    ToolbarBackgroundExample()
}

#Preview("Bottom Toolbar") {
    BottomToolbarExample()
}
