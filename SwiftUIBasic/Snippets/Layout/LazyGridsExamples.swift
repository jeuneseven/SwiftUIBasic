//
//  LazyGridsExamples.swift
//  SwiftUIBasic
//
//  LazyVGrid and LazyHGrid for grid layouts
//

import SwiftUI

// MARK: - Basic LazyVGrid

struct BasicLazyVGridExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Basic LazyVGrid")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(1...12, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.gradient)
                            .frame(height: 80)
                            .overlay {
                                Text("\(number)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Fixed Grid Items

struct FixedGridExample: View {
    let columns = [
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
        GridItem(.fixed(100))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Fixed Width Columns")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Each column is exactly 100pt wide")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(1...9, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.green.gradient)
                            .frame(height: 100)
                            .overlay {
                                Text("\(number)")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Adaptive Grid

struct AdaptiveGridExample: View {
    let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Adaptive Grid")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Columns auto-fit between 80-120pt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(1...20, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.purple.gradient)
                            .frame(height: 80)
                            .overlay {
                                Text("\(number)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Mixed Grid Items

struct MixedGridExample: View {
    let columns = [
        GridItem(.fixed(60)),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Mixed Grid Items")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Text("Fixed(60)").foregroundStyle(.red)
                    Text("+")
                    Text("Flexible").foregroundStyle(.green)
                    Text("+")
                    Text("Flexible").foregroundStyle(.blue)
                }
                .font(.caption)
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<12, id: \.self) { index in
                        let color: Color = index % 3 == 0 ? .red : (index % 3 == 1 ? .green : .blue)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color.gradient)
                            .frame(height: 60)
                            .overlay {
                                Text("\(index + 1)")
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Grid with Alignment

struct GridAlignmentExample: View {
    let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .center),
        GridItem(.flexible(), alignment: .bottom)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Column Alignment")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Text("Top").foregroundStyle(.red)
                    Text("Center").foregroundStyle(.green)
                    Text("Bottom").foregroundStyle(.blue)
                }
                .font(.caption)
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        let heights: [CGFloat] = [60, 100, 80, 90, 70, 110]
                        let colors: [Color] = [.red, .green, .blue]
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colors[index % 3].gradient)
                            .frame(height: heights[index])
                            .overlay {
                                Text("\(index + 1)")
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Grid with Sections

struct GridSectionsExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(1...4, id: \.self) { number in
                        GridCell(number: number, color: .red)
                    }
                } header: {
                    SectionHeader(title: "Section A", color: .red)
                }
                
                Section {
                    ForEach(5...10, id: \.self) { number in
                        GridCell(number: number, color: .green)
                    }
                } header: {
                    SectionHeader(title: "Section B", color: .green)
                }
                
                Section {
                    ForEach(11...16, id: \.self) { number in
                        GridCell(number: number, color: .blue)
                    }
                } header: {
                    SectionHeader(title: "Section C", color: .blue)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GridCell: View {
    let number: Int
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.gradient)
            .frame(height: 80)
            .overlay {
                Text("\(number)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
    }
}

struct SectionHeader: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(color.opacity(0.2))
    }
}

// MARK: - Basic LazyHGrid

struct BasicLazyHGridExample: View {
    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic LazyHGrid")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 12) {
                    ForEach(1...20, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.orange.gradient)
                            .frame(width: 100)
                            .overlay {
                                Text("\(number)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
        .padding(.vertical)
    }
}

// MARK: - Photo Gallery Grid

struct PhotoGalleryGridExample: View {
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 150))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Photo Gallery")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(1...30, id: \.self) { index in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hue: Double(index) / 30, saturation: 0.7, brightness: 0.9),
                                        Color(hue: Double(index) / 30 + 0.1, saturation: 0.8, brightness: 0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .aspectRatio(1, contentMode: .fill)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - App Grid (Home Screen Style)

struct AppInfo: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
}

struct AppGridExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let apps: [AppInfo] = [
        AppInfo(icon: "message.fill", name: "Messages", color: .green),
        AppInfo(icon: "phone.fill", name: "Phone", color: .green),
        AppInfo(icon: "envelope.fill", name: "Mail", color: .blue),
        AppInfo(icon: "safari.fill", name: "Safari", color: .blue),
        AppInfo(icon: "music.note", name: "Music", color: .red),
        AppInfo(icon: "photo.fill", name: "Photos", color: .orange),
        AppInfo(icon: "camera.fill", name: "Camera", color: .gray),
        AppInfo(icon: "gear", name: "Settings", color: .gray),
        AppInfo(icon: "map.fill", name: "Maps", color: .green),
        AppInfo(icon: "clock.fill", name: "Clock", color: .black),
        AppInfo(icon: "calendar", name: "Calendar", color: .red),
        AppInfo(icon: "note.text", name: "Notes", color: .yellow)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("App Grid")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(apps) { app in
                    VStack(spacing: 6) {
                        Image(systemName: app.icon)
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(app.color.gradient)
                            .clipShape(.rect(cornerRadius: 14))
                        
                        Text(app.name)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// MARK: - Calendar Grid

struct CalendarGridExample: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    let today = 15
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Calendar Grid")
                .font(.headline)
            
            Text("February 2026")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: columns, spacing: 8) {
                // Weekday headers
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
                
                // Empty cells for offset (February 2026 starts on Sunday)
                ForEach(0..<0, id: \.self) { _ in
                    Text("")
                }
                
                // Days
                ForEach(1...28, id: \.self) { day in
                    Text("\(day)")
                        .font(.body)
                        .frame(width: 36, height: 36)
                        .background(day == today ? .blue : .clear)
                        .foregroundStyle(day == today ? .white : .primary)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// MARK: - Dynamic Column Count

struct DynamicColumnCountExample: View {
    @State private var columnCount = 3
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columnCount)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Dynamic Columns")
                .font(.headline)
            
            Stepper("Columns: \(columnCount)", value: $columnCount, in: 1...6)
                .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(1...18, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.teal.gradient)
                            .frame(height: 80)
                            .overlay {
                                Text("\(number)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                    }
                }
                .animation(.default, value: columnCount)
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Preview

#Preview("Basic LazyVGrid") {
    BasicLazyVGridExample()
}

#Preview("Fixed Grid") {
    FixedGridExample()
}

#Preview("Adaptive Grid") {
    AdaptiveGridExample()
}

#Preview("Mixed Grid") {
    MixedGridExample()
}

#Preview("Grid Alignment") {
    GridAlignmentExample()
}

#Preview("Grid Sections") {
    GridSectionsExample()
}

#Preview("LazyHGrid") {
    BasicLazyHGridExample()
}

#Preview("Photo Gallery") {
    PhotoGalleryGridExample()
}

#Preview("App Grid") {
    AppGridExample()
}

#Preview("Calendar Grid") {
    CalendarGridExample()
}

#Preview("Dynamic Columns") {
    DynamicColumnCountExample()
}
