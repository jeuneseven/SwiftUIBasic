//
//  ViewStateExamples.swift
//  SwiftUIBasic
//
//  ViewState enum for managing loading, success, error, and empty states
//  Common pattern in MVI architecture for every screen
//

import SwiftUI

// MARK: - Basic ViewState Enum

/// Generic ViewState that represents the four common states of any data-driven view
/// Usage: @State private var state: ViewState<[Order]> = .idle
enum ViewStateExample<T> {
    case idle           // Initial state, nothing happened yet
    case loading        // Fetching data
    case loaded(T)      // Data fetched successfully
    case empty          // Data fetched but result is empty
    case error(String)  // Something went wrong
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

// MARK: - Basic ViewState Usage

struct BasicViewStateExample: View {
    @State private var state: ViewStateExample<[String]> = .idle
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic ViewState")
                .font(.headline)
            
            switch state {
            case .idle:
                Button("Load Data") {
                    Task { await loadData() }
                }
                .buttonStyle(.borderedProminent)
                
            case .loading:
                ProgressView("Loading...")
                
            case .loaded(let items):
                List(items, id: \.self) { item in
                    Text(item)
                }
                .listStyle(.plain)
                .frame(height: 200)
                
            case .empty:
                ContentUnavailableView(
                    "No Items",
                    systemImage: "tray",
                    description: Text("Nothing to show here")
                )
                
            case .error(let message):
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Retry") {
                        Task { await loadData() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
    }
    
    private func loadData() async {
        state = .loading
        try? await Task.sleep(for: .seconds(1.5))
        
        // Simulate different outcomes
        let outcome = Int.random(in: 0...2)
        switch outcome {
        case 0:
            state = .loaded(["Order #1001", "Order #1002", "Order #1003"])
        case 1:
            state = .empty
        default:
            state = .error("Network connection failed")
        }
    }
}

// MARK: - Reusable StateView Container

/// A reusable container that handles all ViewState rendering
/// Wrap your content in this so you don't repeat switch/case everywhere
struct StateViewExample<T, Content: View>: View {
    let state: ViewStateExample<T>
    let retryAction: (() async -> Void)?
    @ViewBuilder let content: (T) -> Content
    
    // Customizable empty state
    var emptyTitle: String = "No Data"
    var emptyIcon: String = "tray"
    var emptyMessage: String = "Nothing to display"
    
    init(
        state: ViewStateExample<T>,
        retryAction: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.state = state
        self.retryAction = retryAction
        self.content = content
    }
    
    var body: some View {
        switch state {
        case .idle:
            Color.clear
            
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let data):
            content(data)
            
        case .empty:
            ContentUnavailableView(
                emptyTitle,
                systemImage: emptyIcon,
                description: Text(emptyMessage)
            )
            
        case .error(let message):
            ContentUnavailableView {
                Label("Something Went Wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                if let retryAction {
                    Button("Retry") {
                        Task { await retryAction() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct StateViewContainerExample: View {
    @State private var state: ViewStateExample<[String]> = .idle
    
    var body: some View {
        NavigationStack {
            StateViewExample(state: state) {
                Task { await loadData() }
            } content: { items in
                List(items, id: \.self) { item in
                    Label(item, systemImage: "shippingbox")
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                Button("Reload") {
                    Task { await loadData() }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        state = .loading
        try? await Task.sleep(for: .seconds(1))
        state = .loaded(["Order #2001 - Auckland CBD", "Order #2002 - Mt Eden", "Order #2003 - Ponsonby"])
    }
}

// MARK: - ViewState with Observable Model

/// Typical usage in MVI: ViewModel holds the ViewState
@Observable
class DeliveryListModel {
    var state: ViewStateExample<[DeliveryItemExample]> = .idle
    
    func loadDeliveries() async {
        state = .loading
        
        // Simulate API call
        try? await Task.sleep(for: .seconds(1.5))
        
        // Simulate success
        let deliveries = [
            DeliveryItemExample(id: "D001", customerName: "Fresh Collective", address: "12 Queen St, Auckland", status: .pending),
            DeliveryItemExample(id: "D002", customerName: "Kai Kitchen", address: "45 Ponsonby Rd", status: .inTransit),
            DeliveryItemExample(id: "D003", customerName: "Urban Bistro", address: "8 Parnell Rise", status: .delivered)
        ]
        
        state = deliveries.isEmpty ? .empty : .loaded(deliveries)
    }
    
    func retry() async {
        await loadDeliveries()
    }
}

struct DeliveryItemExample: Identifiable, Hashable {
    let id: String
    let customerName: String
    let address: String
    let status: DeliveryStatusExample
}

enum DeliveryStatusExample: String, Hashable {
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

struct ObservableViewStateExample: View {
    @State private var model = DeliveryListModel()
    
    var body: some View {
        NavigationStack {
            StateViewExample(state: model.state) {
                await model.retry()
            } content: { deliveries in
                List(deliveries) { delivery in
                    HStack {
                        Image(systemName: delivery.status.icon)
                            .foregroundStyle(delivery.status.color)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(delivery.customerName)
                                .font(.headline)
                            Text(delivery.address)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(delivery.status.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(delivery.status.color.opacity(0.15))
                            .foregroundStyle(delivery.status.color)
                            .clipShape(Capsule())
                    }
                }
            }
            .navigationTitle("Deliveries")
            .refreshable {
                await model.loadDeliveries()
            }
        }
        .task {
            await model.loadDeliveries()
        }
    }
}

// MARK: - Multiple ViewStates on One Screen

/// When a screen has multiple independent data sections
@Observable
class DashboardModel {
    var ordersState: ViewStateExample<Int> = .idle
    var alertsState: ViewStateExample<[String]> = .idle
    
    func loadAll() async {
        async let orders: () = loadOrders()
        async let alerts: () = loadAlerts()
        _ = await (orders, alerts)
    }
    
    private func loadOrders() async {
        ordersState = .loading
        try? await Task.sleep(for: .seconds(1))
        ordersState = .loaded(42)
    }
    
    private func loadAlerts() async {
        alertsState = .loading
        try? await Task.sleep(for: .seconds(1.5))
        alertsState = .loaded(["Cold chain alert: Truck #7", "Delayed: Order #3045"])
    }
}

struct MultipleViewStatesExample: View {
    @State private var dashboard = DashboardModel()
    
    var body: some View {
        NavigationStack {
            List {
                // Orders section with its own state
                Section("Today's Orders") {
                    switch dashboard.ordersState {
                    case .idle, .loading:
                        HStack {
                            ProgressView()
                            Text("Loading orders...")
                                .foregroundStyle(.secondary)
                        }
                    case .loaded(let count):
                        Label("\(count) orders to deliver", systemImage: "shippingbox")
                    case .empty:
                        Text("No orders today")
                            .foregroundStyle(.secondary)
                    case .error(let msg):
                        Label(msg, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
                
                // Alerts section with its own state
                Section("Alerts") {
                    switch dashboard.alertsState {
                    case .idle, .loading:
                        HStack {
                            ProgressView()
                            Text("Checking alerts...")
                                .foregroundStyle(.secondary)
                        }
                    case .loaded(let alerts):
                        ForEach(alerts, id: \.self) { alert in
                            Label(alert, systemImage: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                        }
                    case .empty:
                        Label("All clear", systemImage: "checkmark.circle")
                            .foregroundStyle(.green)
                    case .error(let msg):
                        Label(msg, systemImage: "xmark.circle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await dashboard.loadAll()
            }
        }
        .task {
            await dashboard.loadAll()
        }
    }
}

// MARK: - ViewState Mapping

extension ViewStateExample {
    /// Transform the loaded data type without changing other states
    /// Useful for adapting API models to view models
    func map<U>(_ transform: (T) -> U) -> ViewStateExample<U> {
        switch self {
        case .idle: return .idle
        case .loading: return .loading
        case .loaded(let data): return .loaded(transform(data))
        case .empty: return .empty
        case .error(let message): return .error(message)
        }
    }
}

struct ViewStateMappingExample: View {
    @State private var state: ViewStateExample<[Int]> = .idle
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ViewState Mapping")
                .font(.headline)
            
            // Map raw numbers to formatted strings
            let displayState = state.map { numbers in
                numbers.map { "Order #\($0)" }
            }
            
            StateViewExample(state: displayState) {
                Task { await loadData() }
            } content: { items in
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding(.vertical, 4)
                }
            }
            
            Button("Load") {
                Task { await loadData() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func loadData() async {
        state = .loading
        try? await Task.sleep(for: .seconds(1))
        state = .loaded([3001, 3002, 3003, 3004])
    }
}

// MARK: - Preview

#Preview("Basic ViewState") {
    BasicViewStateExample()
}

#Preview("StateView Container") {
    StateViewContainerExample()
}

#Preview("Observable Model") {
    ObservableViewStateExample()
}

#Preview("Multiple States") {
    MultipleViewStatesExample()
}

#Preview("Mapping") {
    ViewStateMappingExample()
}
