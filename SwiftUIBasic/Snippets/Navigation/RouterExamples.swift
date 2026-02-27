//
//  RouterExamples.swift
//  SwiftUIBasic
//
//  Centralized navigation management with Router pattern
//  Works with MVI architecture for predictable navigation state
//

import SwiftUI

// MARK: - Route Definition

/// Define all possible destinations as an enum
/// Each case carries the data needed for that screen
enum AppRoute: Hashable {
    case orderList
    case orderDetail(orderId: String)
    case customerDetail(customerId: String)
    case deliveryMap(orderId: String)
    case settings
    case profile
}

// MARK: - Router

/// Centralized navigation state manager
/// Inject via .environment() and use from any view or ViewModel
@Observable
class Router {
    var path = NavigationPath()
    
    // Sheet / fullScreenCover state
    var presentedSheet: AppRoute?
    var presentedFullScreen: AppRoute?
    
    // MARK: - Push
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    // MARK: - Pop
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func pop(_ count: Int) {
        let actual = min(count, path.count)
        path.removeLast(actual)
    }
    
    // MARK: - Present
    
    func present(_ route: AppRoute, fullScreen: Bool = false) {
        if fullScreen {
            presentedFullScreen = route
        } else {
            presentedSheet = route
        }
    }
    
    func dismiss() {
        presentedSheet = nil
        presentedFullScreen = nil
    }
    
    // MARK: - Deep Link
    
    /// Handle deep links or notification taps
    /// e.g. bidone://order/D001
    func handleDeepLink(_ url: URL) {
        let components = url.pathComponents.filter { $0 != "/" }
        
        guard let first = components.first else { return }
        
        // Reset to root then navigate
        popToRoot()
        
        switch first {
        case "order":
            if let orderId = components[safe: 1] {
                push(.orderDetail(orderId: orderId))
            }
        case "customer":
            if let customerId = components[safe: 1] {
                push(.customerDetail(customerId: customerId))
            }
        case "settings":
            push(.settings)
        default:
            break
        }
    }
}

// Safe array subscript
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Router Root View

struct RouterRootExample: View {
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            RouterHomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .orderList:
                        RouterOrderListView()
                    case .orderDetail(let id):
                        RouterOrderDetailView(orderId: id)
                    case .customerDetail(let id):
                        RouterCustomerDetailView(customerId: id)
                    case .deliveryMap(let id):
                        RouterMapPlaceholderView(orderId: id)
                    case .settings:
                        RouterSettingsView()
                    case .profile:
                        Text("Profile")
                            .navigationTitle("Profile")
                    }
                }
        }
        .sheet(item: $router.presentedSheet) { route in
            routeView(for: route)
        }
        .fullScreenCover(item: $router.presentedFullScreen) { route in
            routeView(for: route)
        }
        .environment(router)
    }
    
    @ViewBuilder
    private func routeView(for route: AppRoute) -> some View {
        switch route {
        case .settings:
            NavigationStack { RouterSettingsView() }
        default:
            Text("Sheet: \(String(describing: route))")
        }
    }
}

// Make AppRoute work with .sheet(item:)
extension AppRoute: Identifiable {
    var id: String {
        switch self {
        case .orderList: return "orderList"
        case .orderDetail(let id): return "orderDetail_\(id)"
        case .customerDetail(let id): return "customerDetail_\(id)"
        case .deliveryMap(let id): return "deliveryMap_\(id)"
        case .settings: return "settings"
        case .profile: return "profile"
        }
    }
}

// MARK: - Home View (uses Router to navigate)

struct RouterHomeView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Section("Navigation") {
                Button {
                    router.push(.orderList)
                } label: {
                    Label("Orders", systemImage: "shippingbox")
                }
                
                Button {
                    router.push(.settings)
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            
            Section("Direct Push") {
                Button {
                    router.push(.orderDetail(orderId: "D001"))
                } label: {
                    Label("Jump to Order D001", systemImage: "arrow.right.circle")
                }
            }
            
            Section("Sheets") {
                Button {
                    router.present(.settings)
                } label: {
                    Label("Settings (Sheet)", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    router.present(.profile, fullScreen: true)
                } label: {
                    Label("Profile (Full Screen)", systemImage: "person.crop.circle")
                }
            }
            
            Section("Deep Link Simulation") {
                Button {
                    router.handleDeepLink(URL(string: "bidone://order/D099")!)
                } label: {
                    Label("bidone://order/D099", systemImage: "link")
                }
            }
        }
        .navigationTitle("Bidone")
    }
}

// MARK: - Order List → Detail (multi-level push)

struct RouterOrderListView: View {
    @Environment(Router.self) private var router
    
    let orders = ["D001", "D002", "D003"]
    
    var body: some View {
        List(orders, id: \.self) { orderId in
            Button {
                router.push(.orderDetail(orderId: orderId))
            } label: {
                Label("Order \(orderId)", systemImage: "shippingbox")
            }
        }
        .navigationTitle("Orders")
    }
}

struct RouterOrderDetailView: View {
    @Environment(Router.self) private var router
    let orderId: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Order \(orderId)")
                .font(.title)
            
            Button {
                router.push(.customerDetail(customerId: "C_\(orderId)"))
            } label: {
                Label("View Customer", systemImage: "person")
            }
            .buttonStyle(.bordered)
            
            Button {
                router.push(.deliveryMap(orderId: orderId))
            } label: {
                Label("Delivery Map", systemImage: "map")
            }
            .buttonStyle(.bordered)
            
            Button {
                router.popToRoot()
            } label: {
                Label("Back to Home", systemImage: "house")
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Order Detail")
    }
}

struct RouterCustomerDetailView: View {
    let customerId: String
    
    var body: some View {
        Text("Customer: \(customerId)")
            .font(.title2)
            .navigationTitle("Customer")
    }
}

struct RouterMapPlaceholderView: View {
    let orderId: String
    
    var body: some View {
        Text("Map for Order \(orderId)")
            .font(.title2)
            .navigationTitle("Route Map")
    }
}

struct RouterSettingsView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Button("Pop to Root") {
                router.popToRoot()
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Tab + Router (each tab has its own stack)

struct TabRouterExample: View {
    @State private var selectedTab = 0
    @State private var ordersRouter = Router()
    @State private var profileRouter = Router()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $ordersRouter.path) {
                RouterOrderListView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .orderDetail(let id):
                            RouterOrderDetailView(orderId: id)
                        default:
                            EmptyView()
                        }
                    }
            }
            .environment(ordersRouter)
            .tabItem { Label("Orders", systemImage: "shippingbox") }
            .tag(0)
            
            NavigationStack(path: $profileRouter.path) {
                Text("Profile Home")
                    .navigationTitle("Profile")
            }
            .environment(profileRouter)
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(1)
        }
    }
}

// MARK: - Preview

#Preview("Router Root") {
    RouterRootExample()
}

#Preview("Tab + Router") {
    TabRouterExample()
}
