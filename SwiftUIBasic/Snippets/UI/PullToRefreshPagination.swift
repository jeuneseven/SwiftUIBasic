//
//  PullToRefreshPagination.swift
//  SwiftUIBasic
//
//  Pull-to-refresh (.refreshable) and infinite scroll pagination
//

import SwiftUI

// MARK: - Pagination Model

/// Generic pagination state that any list can use
@Observable
class PaginatedListModel<Item: Identifiable> {
    private(set) var items: [Item] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var hasMorePages = true
    private(set) var errorMessage: String?
    
    private var currentPage = 1
    private let pageSize: Int
    private let fetchPage: (Int, Int) async throws -> [Item]
    
    /// - Parameters:
    ///   - pageSize: Items per page (default 20)
    ///   - fetchPage: Closure that takes (page, pageSize) and returns items
    init(
        pageSize: Int = 20,
        fetchPage: @escaping (Int, Int) async throws -> [Item]
    ) {
        self.pageSize = pageSize
        self.fetchPage = fetchPage
    }
    
    /// Initial load or pull-to-refresh
    func refresh() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let newItems = try await fetchPage(currentPage, pageSize)
            items = newItems
            hasMorePages = newItems.count >= pageSize
        } catch {
            errorMessage = AppError.from(error).localizedDescription
        }
        
        isLoading = false
    }
    
    /// Load next page (triggered when scrolling near bottom)
    func loadMoreIfNeeded(currentItem: Item) async {
        guard let index = items.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -3, limitedBy: items.startIndex) ?? items.startIndex
        guard index >= thresholdIndex else { return }
        
        await loadMore()
    }
    
    /// Explicit load more
    func loadMore() async {
        guard !isLoadingMore, hasMorePages else { return }
        
        isLoadingMore = true
        
        do {
            let nextPage = currentPage + 1
            let newItems = try await fetchPage(nextPage, pageSize)
            items.append(contentsOf: newItems)
            currentPage = nextPage
            hasMorePages = newItems.count >= pageSize
        } catch {
            errorMessage = AppError.from(error).localizedDescription
        }
        
        isLoadingMore = false
    }
}

// MARK: - Sample Data

struct PaginatedOrder: Identifiable, Equatable {
    let id: Int
    let customer: String
    let amount: String
    let time: String
}

// MARK: - Basic Pull-to-Refresh + Pagination

struct PullToRefreshPaginationExample: View {
    @State private var model = PaginatedListModel<PaginatedOrder>(
        pageSize: 15,
        fetchPage: { page, size in
            // Simulate API delay
            try await Task.sleep(for: .seconds(1))
            
            let start = (page - 1) * size
            // Simulate 50 total items
            guard start < 50 else { return [] }
            
            let end = min(start + size, 50)
            return (start..<end).map { i in
                PaginatedOrder(
                    id: i,
                    customer: "Customer #\(i + 1)",
                    amount: "$\(Int.random(in: 50...500)).00",
                    time: "\(Int.random(in: 8...17)):00"
                )
            }
        }
    )
    
    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading && model.items.isEmpty {
                    ProgressView("Loading orders...")
                } else if let error = model.errorMessage, model.items.isEmpty {
                    ContentUnavailableView {
                        Label("Error", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button("Retry") { Task { await model.refresh() } }
                            .buttonStyle(.borderedProminent)
                    }
                } else if model.items.isEmpty {
                    ContentUnavailableView("No Orders", systemImage: "tray")
                } else {
                    List {
                        ForEach(model.items) { order in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(order.customer)
                                        .font(.headline)
                                    Text(order.time)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(order.amount)
                                    .fontWeight(.medium)
                            }
                            .onAppear {
                                Task { await model.loadMoreIfNeeded(currentItem: order) }
                            }
                        }
                        
                        // Loading more indicator at bottom
                        if model.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                        
                        // "No more" indicator
                        if !model.hasMorePages && !model.items.isEmpty {
                            HStack {
                                Spacer()
                                Text("All orders loaded")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Orders (\(model.items.count))")
            .refreshable {
                await model.refresh()
            }
        }
        .task {
            await model.refresh()
        }
    }
}

// MARK: - Minimal Pull-to-Refresh Only

/// Simplest refreshable pattern when you don't need pagination
struct SimplePullToRefreshExample: View {
    @State private var items: [String] = []
    @State private var lastUpdated: Date?
    
    var body: some View {
        NavigationStack {
            List {
                if let lastUpdated {
                    Text("Updated: \(lastUpdated.formatted(date: .omitted, time: .standard))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .listRowSeparator(.hidden)
                }
                
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Simple Refresh")
            .refreshable {
                await refreshData()
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("Pull Down to Load", systemImage: "arrow.down")
                }
            }
        }
    }
    
    private func refreshData() async {
        try? await Task.sleep(for: .seconds(1))
        items = (1...10).map { "Refreshed Item \($0) - \(Int.random(in: 100...999))" }
        lastUpdated = .now
    }
}

// MARK: - Scroll-to-Top on Refresh

struct ScrollToTopRefreshExample: View {
    @State private var items = (1...30).map { "Item \($0)" }
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(items, id: \.self) { item in
                    Text(item)
                        .id(item)
                }
                .listStyle(.plain)
                .refreshable {
                    try? await Task.sleep(for: .seconds(0.5))
                    items = (1...30).map { "New Item \($0) - \(Int.random(in: 100...999))" }
                    
                    // Scroll to first item after refresh
                    if let first = items.first {
                        withAnimation {
                            proxy.scrollTo(first, anchor: .top)
                        }
                    }
                }
            }
            .navigationTitle("Scroll to Top")
        }
    }
}

// MARK: - Preview

#Preview("Pagination") {
    PullToRefreshPaginationExample()
}

#Preview("Simple Refresh") {
    SimplePullToRefreshExample()
}

#Preview("Scroll to Top") {
    ScrollToTopRefreshExample()
}
