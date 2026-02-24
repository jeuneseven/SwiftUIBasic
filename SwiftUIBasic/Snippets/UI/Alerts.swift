//
//  Alerts.swift
//  SwiftUIBasic
//
//  Alert and ConfirmationDialog examples
//

import SwiftUI

// MARK: - Basic Alert

struct BasicAlertExample: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Alert Title", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This is the alert message.")
        }
    }
}

// MARK: - Alert with Multiple Buttons

struct MultipleButtonAlertExample: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Delete Item?", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                print("Item deleted")
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

// MARK: - Alert with Data (Presenting Optional)

struct UserData: Identifiable {
    var id = UUID()
    var name: String
}

struct AlertWithDataExample: View {
    @State private var selectedUser: UserData? = nil
    
    var body: some View {
        Button("Select User") {
            selectedUser = UserData(name: "John")
        }
        .alert("User Selected", isPresented: .constant(selectedUser != nil), presenting: selectedUser) { user in
            Button("OK") {
                selectedUser = nil
            }
        } message: { user in
            Text("You selected \(user.name)")
        }
    }
}

// MARK: - Alert with TextField

struct AlertWithTextFieldExample: View {
    @State private var showingAlert = false
    @State private var username = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Username: \(username)")
            
            Button("Enter Username") {
                showingAlert = true
            }
            .alert("Enter Username", isPresented: $showingAlert) {
                TextField("Username", text: $username)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    print("Saved: \(username)")
                }
            } message: {
                Text("Please enter your username.")
            }
        }
    }
}

// MARK: - Confirmation Dialog (Action Sheet)

struct ConfirmationDialogExample: View {
    @State private var showingDialog = false
    @State private var selectedColor = Color.white
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(selectedColor)
                .frame(width: 200, height: 200)
            
            Button("Change Color") {
                showingDialog = true
            }
            .confirmationDialog("Select a Color", isPresented: $showingDialog, titleVisibility: .visible) {
                Button("Red") { selectedColor = .red }
                Button("Green") { selectedColor = .green }
                Button("Blue") { selectedColor = .blue }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Choose a background color")
            }
        }
    }
}

// MARK: - Confirmation Dialog with Destructive Action

struct DestructiveConfirmationDialogExample: View {
    @State private var showingDialog = false
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        VStack {
            List(items, id: \.self) { item in
                Text(item)
            }
            
            Button("Delete All") {
                showingDialog = true
            }
            .confirmationDialog("Delete All Items?", isPresented: $showingDialog, titleVisibility: .visible) {
                Button("Delete All", role: .destructive) {
                    items.removeAll()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all items.")
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic Alert") {
    BasicAlertExample()
}

#Preview("Multiple Buttons") {
    MultipleButtonAlertExample()
}

#Preview("Alert with Data") {
    AlertWithDataExample()
}

#Preview("Alert with TextField") {
    AlertWithTextFieldExample()
}

#Preview("Confirmation Dialog") {
    ConfirmationDialogExample()
}

#Preview("Destructive Dialog") {
    DestructiveConfirmationDialogExample()
}
