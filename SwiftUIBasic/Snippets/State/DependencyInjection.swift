//
//  DependencyInjection.swift
//  SwiftUIBasic
//
//  Dependency injection via Environment + protocol
//  Enables easy mocking for previews and tests
//

import SwiftUI

// MARK: - Define Protocol

/// Abstract away the data source so views don't care if it's real or mock
protocol OrderServiceProtocol {
    func fetchOrders() async throws -> [DIOrder]
    func updateStatus(orderId: String, status: DIOrderStatus) async throws
}

struct DIOrder: Identifiable {
    let id: String
    let customer: String
    let address: String
    var status: DIOrderStatus
}

enum DIOrderStatus: String {
    case pending = "Pending"
    case inTransit = "In Transit"
    case delivered = "Delivered"
}

// MARK: - Real Implementation

/// Hits actual API in production
struct LiveOrderService: OrderServiceProtocol {
    func fetchOrders() async throws -> [DIOrder] {
        // Real app: URLSession call
        try await Task.sleep(for: .seconds(1))
        return [
            DIOrder(id: "D001", customer: "Fresh Collective", address: "12 Queen St", status: .pending),
            DIOrder(id: "D002", customer: "Kai Kitchen", address: "45 Ponsonby Rd", status: .inTransit),
        ]
    }
    
    func updateStatus(orderId: String, status: DIOrderStatus) async throws {
        // Real app: PUT /api/orders/{id}/status
        try await Task.sleep(for: .seconds(0.5))
    }
}

// MARK: - Mock Implementation

/// Instant fake data for previews and tests
struct MockOrderService: OrderServiceProtocol {
    var mockOrders: [DIOrder] = [
        DIOrder(id: "M001", customer: "Mock Cafe", address: "1 Test St", status: .pending),
        DIOrder(id: "M002", customer: "Preview Bistro", address: "2 Fake Ave", status: .delivered),
        DIOrder(id: "M003", customer: "Sample Restaurant", address: "3 Demo Rd", status: .inTransit),
    ]
    var shouldFail = false
    
    func fetchOrders() async throws -> [DIOrder] {
        if shouldFail { throw AppError.networkUnavailable }
        return mockOrders
    }
    
    func updateStatus(orderId: String, status: DIOrderStatus) async throws {
        if shouldFail { throw AppError.serverError(statusCode: 500) }
    }
}

// MARK: - Environment Key

/// Register the protocol in SwiftUI's environment system
struct OrderServiceKey: EnvironmentKey {
    static let defaultValue: any OrderServiceProtocol = LiveOrderService()
}

extension EnvironmentValues {
    var orderService: any OrderServiceProtocol {
        get { self[OrderServiceKey.self] }
        set { self[OrderServiceKey.self] = newValue }
    }
}

// MARK: - ViewModel Using Injected Dependency

@Observable
class DIOrderListModel {
    private let service: any OrderServiceProtocol
    var orders: [DIOrder] = []
    var isLoading = false
    var errorMessage: String?
    
    init(service: any OrderServiceProtocol) {
        self.service = service
    }
    
    func loadOrders() async {
        isLoading = true
        errorMessage = nil
        
        do {
            orders = try await service.fetchOrders()
        } catch {
            errorMessage = AppError.from(error).localizedDescription
        }
        
        isLoading = false
    }
    
    func markDelivered(_ order: DIOrder) async {
        do {
            try await service.updateStatus(orderId: order.id, status: .delivered)
            if let index = orders.firstIndex(where: { $0.id == order.id }) {
                orders[index].status = .delivered
            }
        } catch {
            errorMessage = AppError.from(error).localizedDescription
        }
    }
}

// MARK: - View That Uses DI

struct DIOrderListView: View {
    @Environment(\.orderService) private var orderService
    @State private var model: DIOrderListModel?
    
    var body: some View {
        NavigationStack {
            Group {
                if let model {
                    if model.isLoading {
                        ProgressView("Loading...")
                    } else if let error = model.errorMessage {
                        ContentUnavailableView {
                            Label("Error", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(error)
                        } actions: {
                            Button("Retry") { Task { await model.loadOrders() } }
                                .buttonStyle(.borderedProminent)
                        }
                    } else {
                        List(model.orders) { order in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(order.customer).font(.headline)
                                    Text(order.address).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(order.status.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .swipeActions {
                                if order.status != .delivered {
                                    Button("Delivered") {
                                        Task { await model.markDelivered(order) }
                                    }
                                    .tint(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Orders (DI)")
        }
        .task {
            let m = DIOrderListModel(service: orderService)
            model = m
            await m.loadOrders()
        }
    }
}

// MARK: - Usage: Production vs Preview

/*
 // In App root (production):
 ContentView()
     .environment(\.orderService, LiveOrderService())
 
 // In Preview (instant mock data):
 DIOrderListView()
     .environment(\.orderService, MockOrderService())
 
 // In Preview (error state):
 DIOrderListView()
     .environment(\.orderService, MockOrderService(shouldFail: true))
 */

// MARK: - Multiple Services Pattern

/// When your app has many services, group them
struct AppServices {
    let orderService: any OrderServiceProtocol
    // let authService: any AuthServiceProtocol
    // let locationService: any LocationServiceProtocol
    // let notificationService: any NotificationServiceProtocol
    
    static let live = AppServices(
        orderService: LiveOrderService()
    )
    
    static let mock = AppServices(
        orderService: MockOrderService()
    )
}

struct AppServicesKey: EnvironmentKey {
    static let defaultValue = AppServices.live
}

extension EnvironmentValues {
    var services: AppServices {
        get { self[AppServicesKey.self] }
        set { self[AppServicesKey.self] = newValue }
    }
}

/*
 // Usage:
 @Environment(\.services) private var services
 
 let model = DIOrderListModel(service: services.orderService)
 
 // Root:
 ContentView()
     .environment(\.services, .live)   // production
     .environment(\.services, .mock)   // preview
 */

// MARK: - Preview

#Preview("Live") {
    DIOrderListView()
        .environment(\.orderService, LiveOrderService())
}

#Preview("Mock") {
    DIOrderListView()
        .environment(\.orderService, MockOrderService())
}

#Preview("Error") {
    DIOrderListView()
        .environment(\.orderService, MockOrderService(shouldFail: true))
}
