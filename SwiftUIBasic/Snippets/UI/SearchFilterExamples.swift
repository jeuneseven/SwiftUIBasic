//
//  SearchFilterExamples.swift
//  SwiftUIBasic
//
//  .searchable modifier, filtering, suggestions, and scoped search
//

import SwiftUI

// MARK: - Basic Searchable

struct BasicSearchableExample: View {
    @State private var searchText = ""
    
    let items = [
        "Auckland CBD", "Mt Eden", "Ponsonby",
        "Parnell", "Newmarket", "Grey Lynn",
        "Remuera", "Epsom", "Mt Albert"
    ]
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredItems, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("Delivery Areas")
            .searchable(text: $searchText, prompt: "Search areas")
        }
    }
}

// MARK: - Search with Suggestions

struct SearchSuggestionsExample: View {
    @State private var searchText = ""
    
    let recentSearches = ["Ponsonby", "CBD", "Mt Eden"]
    let allAreas = [
        "Auckland CBD", "Mt Eden", "Ponsonby", "Parnell",
        "Newmarket", "Grey Lynn", "Remuera", "Epsom"
    ]
    
    var filteredAreas: [String] {
        if searchText.isEmpty { return allAreas }
        return allAreas.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredAreas, id: \.self) { area in
                Label(area, systemImage: "mappin")
            }
            .navigationTitle("Areas")
            .searchable(text: $searchText, prompt: "Search or pick recent") {
                if searchText.isEmpty {
                    Section("Recent") {
                        ForEach(recentSearches, id: \.self) { recent in
                            Text(recent)
                                .searchCompletion(recent)
                        }
                    }
                } else {
                    ForEach(filteredAreas, id: \.self) { area in
                        Text(area)
                            .searchCompletion(area)
                    }
                }
            }
        }
    }
}

// MARK: - Scoped Search with Tokens

enum DeliverySearchScope: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case inTransit = "In Transit"
    case delivered = "Delivered"
}

struct ScopedSearchExample: View {
    @State private var searchText = ""
    @State private var scope: DeliverySearchScope = .all
    
    let orders = [
        SampleOrder(id: "D001", customer: "Fresh Collective", status: .pending),
        SampleOrder(id: "D002", customer: "Kai Kitchen", status: .inTransit),
        SampleOrder(id: "D003", customer: "Urban Bistro", status: .delivered),
        SampleOrder(id: "D004", customer: "The Pantry", status: .pending),
        SampleOrder(id: "D005", customer: "Harbourside Cafe", status: .inTransit),
        SampleOrder(id: "D006", customer: "Depot Eatery", status: .delivered),
    ]
    
    var filteredOrders: [SampleOrder] {
        var result = orders
        
        // Apply scope filter
        if scope != .all {
            let targetStatus: SampleOrder.Status = switch scope {
            case .all: .pending // won't reach here
            case .pending: .pending
            case .inTransit: .inTransit
            case .delivered: .delivered
            }
            result = result.filter { $0.status == targetStatus }
        }
        
        // Apply text filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.customer.localizedCaseInsensitiveContains(searchText) ||
                $0.id.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            List(filteredOrders) { order in
                HStack {
                    Image(systemName: order.status.icon)
                        .foregroundStyle(order.status.color)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading) {
                        Text(order.customer)
                            .font(.headline)
                        Text(order.id)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(order.status.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.15))
                        .foregroundStyle(order.status.color)
                        .clipShape(Capsule())
                }
            }
            .navigationTitle("Orders")
            .searchable(text: $searchText, prompt: "Customer or order ID")
            .searchScopes($scope) {
                ForEach(DeliverySearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
        }
    }
}

struct SampleOrder: Identifiable {
    let id: String
    let customer: String
    let status: Status
    
    enum Status: String {
        case pending = "Pending"
        case inTransit = "In Transit"
        case delivered = "Delivered"
        
        var icon: String {
            switch self {
            case .pending: return "clock"
            case .inTransit: return "truck.box"
            case .delivered: return "checkmark.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .inTransit: return .blue
            case .delivered: return .green
            }
        }
    }
}

// MARK: - Search with @Observable Model

@Observable
class SearchableListModel {
    var allItems: [String] = []
    var searchText = ""
    var isSearching = false
    
    var filteredItems: [String] {
        if searchText.isEmpty { return allItems }
        return allItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    func loadItems() async {
        try? await Task.sleep(for: .seconds(0.5))
        allItems = (1...50).map { "Item #\($0) - \(["Auckland", "Wellington", "Christchurch"].randomElement()!)" }
    }
    
    /// Debounced remote search - call API after user stops typing
    func remoteSearch() async {
        isSearching = true
        // Debounce: wait a bit so we don't fire on every keystroke
        try? await Task.sleep(for: .milliseconds(300))
        
        // Check if task was cancelled (user typed again)
        guard !Task.isCancelled else { return }
        
        // Simulate API search
        try? await Task.sleep(for: .seconds(0.5))
        isSearching = false
    }
}

struct ObservableSearchExample: View {
    @State private var model = SearchableListModel()
    @State private var searchTask: Task<Void, Never>?
    
    var body: some View {
        NavigationStack {
            Group {
                if model.isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if model.filteredItems.isEmpty {
                    ContentUnavailableView.search(text: model.searchText)
                } else {
                    List(model.filteredItems, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .navigationTitle("Products")
            .searchable(text: $model.searchText, prompt: "Search products")
            .onChange(of: model.searchText) { _, _ in
                // Cancel previous search, start new debounced one
                searchTask?.cancel()
                searchTask = Task {
                    await model.remoteSearch()
                }
            }
        }
        .task {
            await model.loadItems()
        }
    }
}

// MARK: - Filter Chips

/// Horizontal scrollable filter chips - common pattern for quick filtering
struct FilterChipsExample: View {
    @State private var selectedFilters: Set<String> = []
    @State private var searchText = ""
    
    let filters = ["Chilled", "Frozen", "Dry Goods", "Dairy", "Meat", "Produce", "Beverages"]
    let products = [
        FilterProduct(name: "Whole Milk 2L", category: "Dairy"),
        FilterProduct(name: "Chicken Breast 1kg", category: "Meat"),
        FilterProduct(name: "Frozen Chips 2kg", category: "Frozen"),
        FilterProduct(name: "Basmati Rice 5kg", category: "Dry Goods"),
        FilterProduct(name: "Fresh Lettuce", category: "Produce"),
        FilterProduct(name: "Orange Juice 1L", category: "Beverages"),
        FilterProduct(name: "Cheddar Block 1kg", category: "Dairy"),
        FilterProduct(name: "Lamb Rack", category: "Meat"),
        FilterProduct(name: "Frozen Peas 1kg", category: "Frozen"),
        FilterProduct(name: "Sparkling Water", category: "Beverages"),
    ]
    
    var filteredProducts: [FilterProduct] {
        var result = products
        
        if !selectedFilters.isEmpty {
            result = result.filter { selectedFilters.contains($0.category) }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            let isSelected = selectedFilters.contains(filter)
                            
                            Button {
                                withAnimation(.snappy) {
                                    if isSelected {
                                        selectedFilters.remove(filter)
                                    } else {
                                        selectedFilters.insert(filter)
                                    }
                                }
                            } label: {
                                Text(filter)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(isSelected ? .blue : .gray.opacity(0.15))
                                    .foregroundStyle(isSelected ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Results count
                if !selectedFilters.isEmpty {
                    HStack {
                        Text("\(filteredProducts.count) results")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Button("Clear All") {
                            withAnimation { selectedFilters.removeAll() }
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
                
                // Product list
                List(filteredProducts) { product in
                    HStack {
                        Text(product.name)
                        Spacer()
                        Text(product.category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Products")
            .searchable(text: $searchText, prompt: "Search products")
        }
    }
}

struct FilterProduct: Identifiable {
    let id = UUID()
    let name: String
    let category: String
}

// MARK: - isSearching Environment

struct IsSearchingExample: View {
    @State private var searchText = ""
    let items = ["Auckland", "Wellington", "Christchurch", "Hamilton", "Tauranga"]
    
    var body: some View {
        NavigationStack {
            SearchResultsView(
                searchText: searchText,
                items: items
            )
            .navigationTitle("Cities")
            .searchable(text: $searchText)
        }
    }
}

struct SearchResultsView: View {
    let searchText: String
    let items: [String]
    
    // Detect if search bar is active
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    var filtered: [String] {
        if searchText.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        List {
            if isSearching && filtered.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                ForEach(filtered, id: \.self) { item in
                    Button(item) {
                        dismissSearch()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic Searchable") {
    BasicSearchableExample()
}

#Preview("Suggestions") {
    SearchSuggestionsExample()
}

#Preview("Scoped Search") {
    ScopedSearchExample()
}

#Preview("Observable Search") {
    ObservableSearchExample()
}

#Preview("Filter Chips") {
    FilterChipsExample()
}

#Preview("isSearching") {
    IsSearchingExample()
}
