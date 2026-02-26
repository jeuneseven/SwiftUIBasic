//
//  ObservableExamples.swift
//  SwiftUIBasic
//
//  @Observable macro and state management (iOS 17+)
//

import SwiftUI

// MARK: - Basic @Observable

@Observable
class CounterModel {
    var count = 0
    var step = 1
    
    func increment() {
        count += step
    }
    
    func decrement() {
        count -= step
    }
    
    func reset() {
        count = 0
    }
}

struct BasicObservableExample: View {
    @State private var counter = CounterModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic @Observable")
                .font(.headline)
            
            Text("\(counter.count)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
            
            Stepper("Step: \(counter.step)", value: $counter.step, in: 1...10)
                .padding(.horizontal, 40)
            
            HStack(spacing: 16) {
                Button("−") {
                    counter.decrement()
                }
                .font(.title)
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    counter.reset()
                }
                .buttonStyle(.bordered)
                
                Button("+") {
                    counter.increment()
                }
                .font(.title)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

// MARK: - Observable with Computed Properties

@Observable
class TemperatureModel {
    var celsius: Double = 20
    
    var fahrenheit: Double {
        get { celsius * 9 / 5 + 32 }
        set { celsius = (newValue - 32) * 5 / 9 }
    }
    
    var kelvin: Double {
        celsius + 273.15
    }
    
    var description: String {
        if celsius < 0 {
            return "Freezing"
        } else if celsius < 15 {
            return "Cold"
        } else if celsius < 25 {
            return "Comfortable"
        } else if celsius < 35 {
            return "Warm"
        } else {
            return "Hot"
        }
    }
}

struct ComputedPropertiesExample: View {
    @State private var temp = TemperatureModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Computed Properties")
                .font(.headline)
            
            Text(temp.description)
                .font(.title)
                .foregroundStyle(colorForTemp(temp.celsius))
            
            VStack(spacing: 12) {
                HStack {
                    Text("Celsius:")
                    Spacer()
                    Text("\(temp.celsius, specifier: "%.1f")°C")
                        .fontWeight(.bold)
                }
                
                Slider(value: $temp.celsius, in: -20...50)
                    .tint(colorForTemp(temp.celsius))
                
                HStack {
                    Text("Fahrenheit:")
                    Spacer()
                    Text("\(temp.fahrenheit, specifier: "%.1f")°F")
                }
                
                HStack {
                    Text("Kelvin:")
                    Spacer()
                    Text("\(temp.kelvin, specifier: "%.1f")K")
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding()
    }
    
    private func colorForTemp(_ celsius: Double) -> Color {
        if celsius < 0 { return .blue }
        if celsius < 15 { return .cyan }
        if celsius < 25 { return .green }
        if celsius < 35 { return .orange }
        return .red
    }
}

// MARK: - Observable Array

@Observable
class TodoListModel {
    var items: [TodoListItem] = [
        TodoListItem(title: "Learn SwiftUI"),
        TodoListItem(title: "Build an app"),
        TodoListItem(title: "Ship to App Store")
    ]
    
    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(completedCount) / Double(items.count)
    }
    
    func addItem(_ title: String) {
        items.append(TodoListItem(title: title))
    }
    
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func toggleItem(_ item: TodoListItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
}

struct TodoListItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted = false
}

struct ObservableArrayExample: View {
    @State private var todoList = TodoListModel()
    @State private var newItemTitle = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Observable Array")
                .font(.headline)
            
            // Progress
            VStack(spacing: 4) {
                ProgressView(value: todoList.progress)
                    .tint(.green)
                
                Text("\(todoList.completedCount) of \(todoList.items.count) completed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            // Add new item
            HStack {
                TextField("New item...", text: $newItemTitle)
                    .textFieldStyle(.roundedBorder)
                
                Button("Add") {
                    guard !newItemTitle.isEmpty else { return }
                    todoList.addItem(newItemTitle)
                    newItemTitle = ""
                }
                .buttonStyle(.borderedProminent)
                .disabled(newItemTitle.isEmpty)
            }
            .padding(.horizontal)
            
            // List
            List {
                ForEach(todoList.items) { item in
                    HStack {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isCompleted ? .green : .gray)
                            .onTapGesture {
                                todoList.toggleItem(item)
                            }
                        
                        Text(item.title)
                            .strikethrough(item.isCompleted)
                            .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    }
                }
                .onDelete(perform: todoList.removeItem)
            }
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

// MARK: - Nested Observable

@Observable
class UserProfileModel {
    var name = "John"
    var settings = UserSettingsModel()
}

@Observable
class UserSettingsModel {
    var notificationsEnabled = true
    var darkModeEnabled = false
    var fontSize: Double = 16
}

struct NestedObservableExample: View {
    @State private var profile = UserProfileModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Nested Observable")
                .font(.headline)
            
            // Preview
            Text("Hello, \(profile.name)!")
                .font(.system(size: profile.settings.fontSize))
                .padding()
                .background(profile.settings.darkModeEnabled ? .black : .white)
                .foregroundStyle(profile.settings.darkModeEnabled ? .white : .black)
                .clipShape(.rect(cornerRadius: 12))
            
            Form {
                Section("Profile") {
                    TextField("Name", text: $profile.name)
                }
                
                Section("Settings") {
                    Toggle("Notifications", isOn: $profile.settings.notificationsEnabled)
                    Toggle("Dark Mode", isOn: $profile.settings.darkModeEnabled)
                    
                    VStack(alignment: .leading) {
                        Text("Font Size: \(Int(profile.settings.fontSize))")
                        Slider(value: $profile.settings.fontSize, in: 12...32)
                    }
                }
            }
            .frame(height: 300)
        }
        .padding()
    }
}

// MARK: - @Bindable Usage

@Observable
class FormDataModel {
    var username = ""
    var email = ""
    var agreeToTerms = false
    
    var isValid: Bool {
        !username.isEmpty && email.contains("@") && agreeToTerms
    }
}

struct BindableUsageExample: View {
    @State private var formData = FormDataModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("@Bindable Usage")
                .font(.headline)
            
            // Pass to child view using @Bindable
            FormFieldsView(formData: formData)
            
            Button("Submit") {
                print("Submitting: \(formData.username), \(formData.email)")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!formData.isValid)
            
            if formData.isValid {
                Label("Ready to submit", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
    }
}

struct FormFieldsView: View {
    @Bindable var formData: FormDataModel
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Username", text: $formData.username)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $formData.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            Toggle("I agree to the terms", isOn: $formData.agreeToTerms)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Observable vs ObservableObject Comparison

// Modern way (iOS 17+)
@Observable
class ModernViewModel {
    var value = 0
}

// Legacy way (iOS 13+)
class LegacyViewModel: ObservableObject {
    @Published var value = 0
}

struct ComparisonExample: View {
    // Modern: @State with @Observable class
    @State private var modern = ModernViewModel()
    
    // Legacy: @StateObject with ObservableObject
    @StateObject private var legacy = LegacyViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Observable Comparison")
                .font(.headline)
            
            HStack(spacing: 40) {
                // Modern
                VStack {
                    Text("@Observable")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(modern.value)")
                        .font(.largeTitle)
                    
                    Button("+1") {
                        modern.value += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                
                // Legacy
                VStack {
                    Text("ObservableObject")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(legacy.value)")
                        .font(.largeTitle)
                    
                    Button("+1") {
                        legacy.value += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            
            Text("Both work, but @Observable is simpler")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Shared State with Environment

@Observable
class AppSettingsModel {
    var accentColor: Color = .blue
    var showWelcome = true
}

struct EnvironmentObservableExample: View {
    @State private var settings = AppSettingsModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Shared via Environment")
                .font(.headline)
            
            SettingsControlView()
            
            Divider()
            
            SettingsDisplayView()
        }
        .padding()
        .environment(settings)
    }
}

struct SettingsControlView: View {
    @Environment(AppSettingsModel.self) private var settings
    
    var body: some View {
        @Bindable var settings = settings
        
        VStack(spacing: 12) {
            Text("Controls")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ColorPicker("Accent Color", selection: $settings.accentColor)
            Toggle("Show Welcome", isOn: $settings.showWelcome)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct SettingsDisplayView: View {
    @Environment(AppSettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Preview")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if settings.showWelcome {
                Text("Welcome!")
                    .font(.title)
                    .foregroundStyle(settings.accentColor)
            }
            
            Button("Sample Button") { }
                .buttonStyle(.borderedProminent)
                .tint(settings.accentColor)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview("Basic Observable") {
    BasicObservableExample()
}

#Preview("Computed Properties") {
    ComputedPropertiesExample()
}

#Preview("Observable Array") {
    ObservableArrayExample()
}

#Preview("Nested Observable") {
    NestedObservableExample()
}

#Preview("@Bindable Usage") {
    BindableUsageExample()
}

#Preview("Comparison") {
    ComparisonExample()
}

#Preview("Environment") {
    EnvironmentObservableExample()
}
