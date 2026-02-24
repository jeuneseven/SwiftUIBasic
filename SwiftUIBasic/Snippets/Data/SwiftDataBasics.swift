//
//  SwiftDataBasics.swift
//  SwiftUIBasic
//
//  SwiftData model, @Model, @Query, and CRUD operations
//

import SwiftUI
import SwiftData

// MARK: - Basic Model

@Model // @Model macro builds on @Observable for SwiftUI integration
class TodoItem {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var priority: Int
    
    init(title: String, isCompleted: Bool = false, priority: Int = 0) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date.now
        self.priority = priority
    }
}

// MARK: - Basic CRUD Operations

struct BasicSwiftDataExample: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todoItems: [TodoItem]
    
    @State private var newItemTitle = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New item", text: $newItemTitle)
                        
                        Button("Add", systemImage: "plus") {
                            addItem()
                        }
                        .disabled(newItemTitle.isEmpty)
                    }
                }
                
                Section("Items (\(todoItems.count))") {
                    ForEach(todoItems) { item in
                        TodoItemRow(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("SwiftData Demo")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func addItem() {
        let item = TodoItem(title: newItemTitle)
        modelContext.insert(item)
        newItemTitle = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todoItems[index])
        }
    }
}

struct TodoItemRow: View {
    @Bindable var item: TodoItem
    
    var body: some View {
        HStack {
            Button {
                item.isCompleted.toggle()
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundStyle(item.isCompleted ? .secondary : .primary)
        }
    }
}

// MARK: - @Query with Sort and Filter

struct QuerySortFilterExample: View {
    @Environment(\.modelContext) private var modelContext
    
    // Sort by priority (descending), then by creation date
    @Query(sort: [
        SortDescriptor(\TodoItem.priority, order: .reverse),
        SortDescriptor(\TodoItem.createdAt)
    ])
    private var allItems: [TodoItem]
    
    // Filter: only incomplete items
    @Query(filter: #Predicate<TodoItem> { item in
        item.isCompleted == false
    })
    private var incompleteItems: [TodoItem]
    
    // Filter with sort
    @Query(
        filter: #Predicate<TodoItem> { $0.priority > 0 },
        sort: \TodoItem.priority,
        order: .reverse
    )
    private var highPriorityItems: [TodoItem]
    
    var body: some View {
        NavigationStack {
            List {
                Section("All Items (Sorted)") {
                    ForEach(allItems) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            Text("P\(item.priority)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Incomplete Only") {
                    ForEach(incompleteItems) { item in
                        Text(item.title)
                    }
                }
                
                Section("High Priority (P > 0)") {
                    ForEach(highPriorityItems) { item in
                        Text(item.title)
                    }
                }
            }
            .navigationTitle("Query Examples")
            .toolbar {
                Button("Add Sample") {
                    addSampleItems()
                }
            }
        }
    }
    
    private func addSampleItems() {
        let priorities = [0, 1, 2, 3]
        for i in 1...3 {
            let item = TodoItem(
                title: "Item \(allItems.count + i)",
                priority: priorities.randomElement() ?? 0
            )
            modelContext.insert(item)
        }
    }
}

// MARK: - Dynamic Query with @Query Initializer

struct DynamicQueryExample: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showCompletedOnly = false
    @State private var sortByDate = true
    
    var body: some View {
        NavigationStack {
            VStack {
                // Controls
                Form {
                    Toggle("Show Completed Only", isOn: $showCompletedOnly)
                    Toggle("Sort by Date", isOn: $sortByDate)
                }
                .frame(height: 150)
                
                // Dynamic content
                TodoItemListView(
                    showCompletedOnly: showCompletedOnly,
                    sortByDate: sortByDate
                )
            }
            .navigationTitle("Dynamic Query")
        }
    }
}

struct TodoItemListView: View {
    @Query private var items: [TodoItem]
    
    init(showCompletedOnly: Bool, sortByDate: Bool) {
        let predicate: Predicate<TodoItem>? = showCompletedOnly
            ? #Predicate { $0.isCompleted == true }
            : nil
        
        let sortDescriptor = sortByDate
            ? SortDescriptor(\TodoItem.createdAt, order: .reverse)
            : SortDescriptor(\TodoItem.title)
        
        _items = Query(filter: predicate, sort: [sortDescriptor])
    }
    
    var body: some View {
        List(items) { item in
            HStack {
                Text(item.title)
                Spacer()
                if item.isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
            }
        }
    }
}

// MARK: - Model with Relationships

@Model
class Author {
    var name: String
    // One-to-many relationship
    @Relationship(deleteRule: .cascade)
    var books: [Book] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Book {
    var title: String
    var publishedYear: Int
    // Inverse relationship
    var author: Author?
    
    init(title: String, publishedYear: Int) {
        self.title = title
        self.publishedYear = publishedYear
    }
}

struct RelationshipExample: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var authors: [Author]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(authors) { author in
                    Section(author.name) {
                        ForEach(author.books) { book in
                            HStack {
                                Text(book.title)
                                Spacer()
                                Text("\(book.publishedYear)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Button("Add Book") {
                            let book = Book(
                                title: "Book \(author.books.count + 1)",
                                publishedYear: 2024
                            )
                            author.books.append(book)
                        }
                    }
                }
                .onDelete(perform: deleteAuthors)
            }
            .navigationTitle("Authors & Books")
            .toolbar {
                Button("Add Author") {
                    let author = Author(name: "Author \(authors.count + 1)")
                    modelContext.insert(author)
                }
            }
        }
    }
    
    private func deleteAuthors(at offsets: IndexSet) {
        for index in offsets {
            // Cascade delete will also remove all books
            modelContext.delete(authors[index])
        }
    }
}

// MARK: - Model with Unique Constraint

@Model
class AppUser {
    @Attribute(.unique)
    var email: String
    var name: String
    var joinedAt: Date
    
    init(email: String, name: String) {
        self.email = email
        self.name = name
        self.joinedAt = Date.now
    }
}

struct UniqueConstraintExample: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]
    
    @State private var email = ""
    @State private var name = ""
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Add User") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Name", text: $name)
                    
                    Button("Add") {
                        addUser()
                    }
                    .disabled(email.isEmpty || name.isEmpty)
                }
                
                Section("Users (\(users.count))") {
                    ForEach(users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteUsers)
                }
            }
            .navigationTitle("Unique Constraint")
            .alert("Error", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text("A user with this email already exists.")
            }
        }
    }
    
    private func addUser() {
        // Check for existing email
        let existingUser = users.first { $0.email == email }
        if existingUser != nil {
            showError = true
            return
        }
        
        let user = AppUser(email: email, name: name)
        modelContext.insert(user)
        email = ""
        name = ""
    }
    
    private func deleteUsers(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(users[index])
        }
    }
}

// MARK: - Model Container Setup

struct SwiftDataContainerExample: View {
    var body: some View {
        Text("Configure in App file")
            .padding()
    }
}

/*
 // In your App file:
 
 import SwiftUI
 import SwiftData
 
 @main
 struct MyApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
         // Basic container
         .modelContainer(for: [TodoItem.self, Author.self, Book.self, AppUser.self])
         
         // Or with configuration
         // .modelContainer(for: TodoItem.self, inMemory: true) // For previews/testing
     }
 }
 
 // For previews:
 #Preview {
     BasicSwiftDataExample()
         .modelContainer(for: TodoItem.self, inMemory: true)
 }
 */

// MARK: - Manual Save

struct ManualSaveExample: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TodoItem]
    
    var body: some View {
        NavigationStack {
            List(items) { item in
                Text(item.title)
            }
            .navigationTitle("Manual Save")
            .toolbar {
                Button("Add & Save") {
                    let item = TodoItem(title: "Item \(items.count + 1)")
                    modelContext.insert(item)
                    
                    // Explicitly save (usually automatic)
                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save: \(error)")
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic CRUD") {
    BasicSwiftDataExample()
        .modelContainer(for: TodoItem.self, inMemory: true)
}

#Preview("Query Sort & Filter") {
    QuerySortFilterExample()
        .modelContainer(for: TodoItem.self, inMemory: true)
}

#Preview("Dynamic Query") {
    DynamicQueryExample()
        .modelContainer(for: TodoItem.self, inMemory: true)
}

#Preview("Relationships") {
    RelationshipExample()
        .modelContainer(for: [Author.self, Book.self], inMemory: true)
}

#Preview("Unique Constraint") {
    UniqueConstraintExample()
        .modelContainer(for: AppUser.self, inMemory: true)
}
