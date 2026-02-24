//
//  UserDefaults.swift
//  SwiftUIBasic
//
//  UserDefaults, @AppStorage, and simple data persistence
//

import SwiftUI

// MARK: - Basic UserDefaults

struct BasicUserDefaultsExample: View {
    private static let tapCountKey = "TapCount"
    @State private var tapCount = UserDefaults.standard.integer(forKey: tapCountKey)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tap Count: \(tapCount)")
                .font(.largeTitle)
            
            Button("Increment") {
                tapCount += 1
                UserDefaults.standard.set(tapCount, forKey: Self.tapCountKey)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Reset") {
                tapCount = 0
                UserDefaults.standard.set(0, forKey: Self.tapCountKey)
            }
            .buttonStyle(.bordered)
            
            Text("Value persists across app launches")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - @AppStorage (Recommended)

struct AppStorageExample: View {
    // @AppStorage is more reliable than manual UserDefaults
    // Automatically syncs with UserDefaults
    @AppStorage("username") private var username = ""
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = true
    @AppStorage("fontSize") private var fontSize = 16.0
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    
    var body: some View {
        Form {
            Section("Profile") {
                TextField("Username", text: $username)
            }
            
            Section("Preferences") {
                Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                
                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 12...24, step: 1)
                }
                
                Picker("Theme", selection: $selectedTheme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
            }
            
            Section {
                Button("Reset All") {
                    username = ""
                    isNotificationsEnabled = true
                    fontSize = 16.0
                    selectedTheme = "system"
                }
                .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - @AppStorage with Custom Store

struct AppStorageCustomStoreExample: View {
    // Use a custom UserDefaults suite (useful for App Groups)
    @AppStorage("sharedValue", store: UserDefaults(suiteName: "group.com.example.app"))
    private var sharedValue = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Shared Value", text: $sharedValue)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Text("This value can be shared with app extensions")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - @AppStorage with RawRepresentable Enum

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

struct AppStorageEnumExample: View {
    // Enums with RawValue work directly with @AppStorage
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    var body: some View {
        Form {
            Picker("App Theme", selection: $appTheme) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            
            Text("Current theme: \(appTheme.displayName)")
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Storing Codable Objects

struct UserSettings: Codable {
    var name: String
    var email: String
    var age: Int
    var isPremium: Bool
}

struct CodableUserDefaultsExample: View {
    private static let settingsKey = "UserSettings"
    @State private var settings = UserSettings(
        name: "",
        email: "",
        age: 18,
        isPremium: false
    )
    
    var body: some View {
        Form {
            Section("User Info") {
                TextField("Name", text: $settings.name)
                TextField("Email", text: $settings.email)
                    .keyboardType(.emailAddress)
                Stepper("Age: \(settings.age)", value: $settings.age, in: 1...120)
                Toggle("Premium User", isOn: $settings.isPremium)
            }
            
            Section {
                Button("Save") {
                    saveSettings()
                }
                
                Button("Load") {
                    loadSettings()
                }
                
                Button("Clear") {
                    UserDefaults.standard.removeObject(forKey: Self.settingsKey)
                    settings = UserSettings(name: "", email: "", age: 18, isPremium: false)
                }
                .foregroundStyle(.red)
            }
        }
        .onAppear {
            loadSettings()
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: Self.settingsKey)
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: Self.settingsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            settings = decoded
        }
    }
}

// MARK: - @AppStorage with Data (Codable wrapper)

extension UserDefaults {
    func setCodable<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            set(encoded, forKey: key)
        }
    }
    
    func codable<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: - UserDefaults Data Types

struct UserDefaultsDataTypesExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("UserDefaults Data Types")
                .font(.headline)
            
            Button("Test All Types") {
                testAllTypes()
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func testAllTypes() {
        let defaults = UserDefaults.standard
        var results: [String] = []
        
        // String
        defaults.set("Hello", forKey: "testString")
        let string = defaults.string(forKey: "testString") ?? ""
        results.append("String: \(string)")
        
        // Int
        defaults.set(42, forKey: "testInt")
        let int = defaults.integer(forKey: "testInt")
        results.append("Int: \(int)")
        
        // Double
        defaults.set(3.14159, forKey: "testDouble")
        let double = defaults.double(forKey: "testDouble")
        results.append("Double: \(double)")
        
        // Bool
        defaults.set(true, forKey: "testBool")
        let bool = defaults.bool(forKey: "testBool")
        results.append("Bool: \(bool)")
        
        // Date
        let date = Date.now
        defaults.set(date, forKey: "testDate")
        let loadedDate = defaults.object(forKey: "testDate") as? Date
        results.append("Date: \(loadedDate?.formatted() ?? "nil")")
        
        // Array
        defaults.set(["A", "B", "C"], forKey: "testArray")
        let array = defaults.array(forKey: "testArray") as? [String] ?? []
        results.append("Array: \(array)")
        
        // Dictionary
        defaults.set(["name": "Swift", "version": 5], forKey: "testDict")
        let dict = defaults.dictionary(forKey: "testDict") ?? [:]
        results.append("Dict: \(dict)")
        
        // URL
        defaults.set(URL(string: "https://apple.com"), forKey: "testURL")
        let url = defaults.url(forKey: "testURL")
        results.append("URL: \(url?.absoluteString ?? "nil")")
        
        output = results.joined(separator: "\n")
    }
}

// MARK: - Observable Settings Class

import Observation

@Observable
class SettingsManager {
    private let defaults = UserDefaults.standard
    
    var isDarkMode: Bool {
        didSet { defaults.set(isDarkMode, forKey: "isDarkMode") }
    }
    
    var accentColorName: String {
        didSet { defaults.set(accentColorName, forKey: "accentColorName") }
    }
    
    var notificationSound: String {
        didSet { defaults.set(notificationSound, forKey: "notificationSound") }
    }
    
    init() {
        self.isDarkMode = defaults.bool(forKey: "isDarkMode")
        self.accentColorName = defaults.string(forKey: "accentColorName") ?? "blue"
        self.notificationSound = defaults.string(forKey: "notificationSound") ?? "default"
    }
}

struct ObservableSettingsExample: View {
    @State private var settings = SettingsManager()
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $settings.isDarkMode)
                
                Picker("Accent Color", selection: $settings.accentColorName) {
                    Text("Blue").tag("blue")
                    Text("Purple").tag("purple")
                    Text("Green").tag("green")
                    Text("Orange").tag("orange")
                }
            }
            
            Section("Sounds") {
                Picker("Notification Sound", selection: $settings.notificationSound) {
                    Text("Default").tag("default")
                    Text("Chime").tag("chime")
                    Text("Bell").tag("bell")
                    Text("None").tag("none")
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic UserDefaults") {
    BasicUserDefaultsExample()
}

#Preview("@AppStorage") {
    AppStorageExample()
}

#Preview("@AppStorage Enum") {
    AppStorageEnumExample()
}

#Preview("Codable Objects") {
    CodableUserDefaultsExample()
}

#Preview("Data Types") {
    UserDefaultsDataTypesExample()
}

#Preview("Observable Settings") {
    ObservableSettingsExample()
}
