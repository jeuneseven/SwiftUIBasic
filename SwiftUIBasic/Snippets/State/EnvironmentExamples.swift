//
//  EnvironmentExamples.swift
//  SwiftUIBasic
//
//  Environment values and custom environment keys
//

import SwiftUI

// MARK: - System Environment Values

struct SystemEnvironmentExample: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar
    
    var body: some View {
        VStack(spacing: 20) {
            Text("System Environment")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                EnvironmentRow(
                    label: "Color Scheme",
                    value: colorScheme == .dark ? "Dark" : "Light",
                    icon: colorScheme == .dark ? "moon.fill" : "sun.max.fill"
                )
                
                EnvironmentRow(
                    label: "Dynamic Type",
                    value: "\(dynamicTypeSize)",
                    icon: "textformat.size"
                )
                
                EnvironmentRow(
                    label: "Horizontal Size",
                    value: horizontalSizeClass == .compact ? "Compact" : "Regular",
                    icon: "arrow.left.and.right"
                )
                
                EnvironmentRow(
                    label: "Vertical Size",
                    value: verticalSizeClass == .compact ? "Compact" : "Regular",
                    icon: "arrow.up.and.down"
                )
                
                EnvironmentRow(
                    label: "Locale",
                    value: locale.identifier,
                    icon: "globe"
                )
                
                EnvironmentRow(
                    label: "First Weekday",
                    value: calendar.weekdaySymbols[calendar.firstWeekday - 1],
                    icon: "calendar"
                )
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding()
    }
}

struct EnvironmentRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.blue)
            
            Text(label)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Dismiss Environment

struct DismissEnvironmentExample: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dismiss Environment")
                .font(.headline)
            
            Button("Show Sheet") {
                showSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showSheet) {
            DismissableSheet()
        }
    }
}

struct DismissableSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sheet Content")
                .font(.title)
            
            Text("Use @Environment(\\.dismiss) to close")
                .foregroundStyle(.secondary)
            
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Open URL Environment

struct OpenURLEnvironmentExample: View {
    @Environment(\.openURL) private var openURL
    
    let links = [
        ("Apple", "https://apple.com"),
        ("GitHub", "https://github.com"),
        ("Stack Overflow", "https://stackoverflow.com")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Open URL Environment")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(links, id: \.0) { link in
                    Button {
                        if let url = URL(string: link.1) {
                            openURL(url)
                        }
                    } label: {
                        HStack {
                            Text(link.0)
                            Spacer()
                            Image(systemName: "safari")
                        }
                        .padding()
                        .background(.blue.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Custom Environment Key

struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

struct FontStyleKey: EnvironmentKey {
    static let defaultValue: Font = .body
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
    
    var customFont: Font {
        get { self[FontStyleKey.self] }
        set { self[FontStyleKey.self] = newValue }
    }
}

struct CustomEnvironmentKeyExample: View {
    @State private var selectedColor: Color = .blue
    @State private var selectedFont: Int = 0
    
    let fonts: [Font] = [.body, .title3, .title, .largeTitle]
    let fontNames = ["Body", "Title 3", "Title", "Large Title"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Environment Key")
                .font(.headline)
            
            // Controls
            VStack(spacing: 12) {
                ColorPicker("Theme Color", selection: $selectedColor)
                
                Picker("Font", selection: $selectedFont) {
                    ForEach(0..<fontNames.count, id: \.self) { index in
                        Text(fontNames[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            
            // Child views inherit environment
            ThemedChildView()
                .environment(\.themeColor, selectedColor)
                .environment(\.customFont, fonts[selectedFont])
        }
        .padding()
    }
}

struct ThemedChildView: View {
    @Environment(\.themeColor) private var themeColor
    @Environment(\.customFont) private var customFont
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Themed Content")
                .font(customFont)
                .foregroundStyle(themeColor)
            
            Button("Themed Button") { }
                .buttonStyle(.borderedProminent)
                .tint(themeColor)
            
            Circle()
                .fill(themeColor.gradient)
                .frame(width: 60, height: 60)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Environment Object (Legacy)

class LegacySettingsStore: ObservableObject {
    @Published var username = "Guest"
    @Published var isLoggedIn = false
}

struct EnvironmentObjectExample: View {
    @StateObject private var settings = LegacySettingsStore()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("@EnvironmentObject (Legacy)")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("Username", text: $settings.username)
                    .textFieldStyle(.roundedBorder)
                
                Toggle("Logged In", isOn: $settings.isLoggedIn)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            
            LegacyChildView()
        }
        .padding()
        .environmentObject(settings)
    }
}

struct LegacyChildView: View {
    @EnvironmentObject var settings: LegacySettingsStore
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Child View")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if settings.isLoggedIn {
                Label("Welcome, \(settings.username)!", systemImage: "person.fill")
                    .foregroundStyle(.green)
            } else {
                Label("Please log in", systemImage: "person.slash")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - IsEnabled Environment

struct IsEnabledEnvironmentExample: View {
    @State private var isEnabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("IsEnabled Environment")
                .font(.headline)
            
            Toggle("Enable Controls", isOn: $isEnabled)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button("Button 1") { }
                    .buttonStyle(.borderedProminent)
                
                Button("Button 2") { }
                    .buttonStyle(.bordered)
                
                TextField("Text Field", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                
                Slider(value: .constant(0.5))
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            .disabled(!isEnabled)
        }
        .padding()
    }
}

// MARK: - Refresh Action

struct RefreshActionExample: View {
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Pull to Refresh")
                .font(.headline)
                .padding()
            
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await loadMoreItems()
            }
        }
    }
    
    private func loadMoreItems() async {
        try? await Task.sleep(for: .seconds(1))
        let newItem = "Item \(items.count + 1)"
        items.append(newItem)
    }
}

// MARK: - Edit Mode Environment

struct EditModeEnvironmentExample: View {
    @State private var items = ["Apple", "Banana", "Cherry", "Date"]
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Edit Mode")
                    .font(.headline)
                
                Spacer()
                
                Button(editMode.isEditing ? "Done" : "Edit") {
                    withAnimation {
                        editMode = editMode.isEditing ? .inactive : .active
                    }
                }
            }
            .padding()
            
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
                .onMove { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
            }
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
        }
    }
}

// MARK: - Preview

#Preview("System Environment") {
    SystemEnvironmentExample()
}

#Preview("Dismiss") {
    DismissEnvironmentExample()
}

#Preview("Open URL") {
    OpenURLEnvironmentExample()
}

#Preview("Custom Key") {
    CustomEnvironmentKeyExample()
}

#Preview("EnvironmentObject") {
    EnvironmentObjectExample()
}

#Preview("IsEnabled") {
    IsEnabledEnvironmentExample()
}

#Preview("Refresh Action") {
    RefreshActionExample()
}

#Preview("Edit Mode") {
    EditModeEnvironmentExample()
}
