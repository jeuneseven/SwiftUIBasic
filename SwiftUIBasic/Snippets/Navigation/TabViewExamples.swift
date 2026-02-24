//
//  TabView.swift
//  SwiftUIBasic
//
//  TabView, Tab, and tab bar customization
//

import SwiftUI

// MARK: - Basic TabView

struct BasicTabViewExample: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Text("Home View")
                    .font(.largeTitle)
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                Text("Search View")
                    .font(.largeTitle)
            }
            
            Tab("Profile", systemImage: "person") {
                Text("Profile View")
                    .font(.largeTitle)
            }
        }
    }
}

// MARK: - TabView with Navigation

struct TabViewWithNavigationExample: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    List(0..<10) { index in
                        NavigationLink("Item \(index)") {
                            Text("Detail for Item \(index)")
                        }
                    }
                    .navigationTitle("Home")
                }
            }
            
            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    List {
                        NavigationLink("Account") {
                            Text("Account Settings")
                        }
                        NavigationLink("Notifications") {
                            Text("Notification Settings")
                        }
                    }
                    .navigationTitle("Settings")
                }
            }
        }
    }
}

// MARK: - Programmatic Tab Selection

struct ProgrammaticTabSelectionExample: View {
    @State private var selectedTab = "home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: "home") {
                VStack(spacing: 20) {
                    Text("Home View")
                        .font(.largeTitle)
                    
                    Button("Go to Settings") {
                        selectedTab = "settings"
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: "search") {
                VStack(spacing: 20) {
                    Text("Search View")
                        .font(.largeTitle)
                    
                    Button("Go to Home") {
                        selectedTab = "home"
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Tab("Settings", systemImage: "gear", value: "settings") {
                VStack(spacing: 20) {
                    Text("Settings View")
                        .font(.largeTitle)
                    
                    Button("Go to Search") {
                        selectedTab = "search"
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

// MARK: - TabView with Badge

struct TabViewWithBadgeExample: View {
    @State private var messageCount = 3
    @State private var notificationCount = 12
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Text("Home View")
            }
            
            Tab("Messages", systemImage: "message") {
                VStack(spacing: 20) {
                    Text("Messages View")
                    
                    Button("Clear Messages") {
                        messageCount = 0
                    }
                }
            }
            .badge(messageCount)
            
            Tab("Notifications", systemImage: "bell") {
                VStack(spacing: 20) {
                    Text("Notifications View")
                    
                    Button("Add Notification") {
                        notificationCount += 1
                    }
                }
            }
            .badge(notificationCount)
            
            Tab("Profile", systemImage: "person") {
                Text("Profile View")
            }
            // String badge
            .badge("New")
        }
    }
}

// MARK: - Tab Sections (iPadOS Sidebar)

struct TabSectionsExample: View {
    @State private var selectedTab = "home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Primary tabs always visible
            Tab("Home", systemImage: "house", value: "home") {
                Text("Home View")
                    .font(.largeTitle)
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: "search") {
                Text("Search View")
                    .font(.largeTitle)
            }
            
            // Tab section - creates collapsible group on iPad
            TabSection("Library") {
                Tab("Books", systemImage: "book", value: "books") {
                    Text("Books View")
                }
                
                Tab("Music", systemImage: "music.note", value: "music") {
                    Text("Music View")
                }
                
                Tab("Videos", systemImage: "film", value: "videos") {
                    Text("Videos View")
                }
            }
            
            TabSection("Settings") {
                Tab("Account", systemImage: "person.circle", value: "account") {
                    Text("Account View")
                }
                
                Tab("Preferences", systemImage: "gear", value: "preferences") {
                    Text("Preferences View")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

// MARK: - Page Style TabView

struct PageStyleTabViewExample: View {
    var body: some View {
        TabView {
            OnboardingPage(
                title: "Welcome",
                description: "Discover amazing features",
                imageName: "hand.wave",
                color: .blue
            )
            
            OnboardingPage(
                title: "Explore",
                description: "Find what you need",
                imageName: "magnifyingglass",
                color: .purple
            )
            
            OnboardingPage(
                title: "Get Started",
                description: "Begin your journey",
                imageName: "arrow.right.circle",
                color: .green
            )
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundStyle(color)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(description)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

// MARK: - Page Style with Manual Index

struct ManualPageIndexExample: View {
    @State private var currentPage = 0
    let pageCount = 4
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Text("Page \(index + 1)")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(hue: Double(index) / Double(pageCount), saturation: 0.3, brightness: 1.0))
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.primary : Color.secondary.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            withAnimation {
                                currentPage = index
                            }
                        }
                }
            }
            .padding()
        }
    }
}

// MARK: - Tab Bar Appearance

struct TabBarAppearanceExample: View {
    init() {
        // Customize tab bar appearance globally
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
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
            }
            
            Tab("Settings", systemImage: "gear") {
                Text("Settings")
            }
        }
        .tint(.purple)
    }
}

// MARK: - Hide Tab Bar

struct HideTabBarExample: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    List {
                        NavigationLink("Go to Detail") {
                            Text("Detail View")
                                .navigationTitle("Detail")
                                // Hide tab bar in detail view
                                .toolbar(.hidden, for: .tabBar)
                        }
                    }
                    .navigationTitle("Home")
                }
            }
            
            Tab("Settings", systemImage: "gear") {
                Text("Settings")
            }
        }
    }
}

// MARK: - Custom Tab Item View

struct CustomTabItemExample: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            TabView(selection: $selectedTab) {
                Text("Home Content")
                    .tag(0)
                
                Text("Search Content")
                    .tag(1)
                
                Text("Profile Content")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom tab bar
            HStack {
                CustomTabButton(
                    icon: "house",
                    title: "Home",
                    isSelected: selectedTab == 0
                ) {
                    selectedTab = 0
                }
                
                CustomTabButton(
                    icon: "magnifyingglass",
                    title: "Search",
                    isSelected: selectedTab == 1
                ) {
                    selectedTab = 1
                }
                
                CustomTabButton(
                    icon: "person",
                    title: "Profile",
                    isSelected: selectedTab == 2
                ) {
                    selectedTab = 2
                }
            }
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
        }
    }
}

struct CustomTabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "\(icon).fill" : icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.caption2)
            }
            .foregroundStyle(isSelected ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicTabViewExample()
}

#Preview("With Navigation") {
    TabViewWithNavigationExample()
}

#Preview("Programmatic Selection") {
    ProgrammaticTabSelectionExample()
}

#Preview("With Badge") {
    TabViewWithBadgeExample()
}

#Preview("Tab Sections") {
    TabSectionsExample()
}

#Preview("Page Style") {
    PageStyleTabViewExample()
}

#Preview("Manual Page Index") {
    ManualPageIndexExample()
}

#Preview("Tab Bar Appearance") {
    TabBarAppearanceExample()
}

#Preview("Hide Tab Bar") {
    HideTabBarExample()
}

#Preview("Custom Tab Item") {
    CustomTabItemExample()
}
