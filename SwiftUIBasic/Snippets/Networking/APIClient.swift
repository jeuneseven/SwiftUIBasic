//
//  APIClient.swift
//  SwiftUIBasic
//
//  Unified API client that combines URLSession, Codable, error handling,
//  auth token injection, and retry logic
//  Depends on: ErrorHandling.swift, AuthExamples.swift
//

import SwiftUI

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - API Endpoint

/// Describes a single API endpoint
struct APIEndpoint<Response: Decodable> {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: (any Encodable)?
    let requiresAuth: Bool
    
    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable)? = nil,
        requiresAuth: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.requiresAuth = requiresAuth
    }
}

// MARK: - API Client

/// Central network client — one instance for the whole app
@Observable
class APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let authManager: AuthManager?
    
    init(
        baseURL: URL,
        authManager: AuthManager? = nil,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.authManager = authManager
        self.session = session
        
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        self.encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Core Request
    
    /// Execute an API endpoint with automatic auth, decoding, and error mapping
    func request<T: Decodable>(_ endpoint: APIEndpoint<T>) async throws -> T {
        let request = try await buildRequest(for: endpoint)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }
        
        // Check for HTTP errors
        if let error = AppError.fromStatusCode(httpResponse.statusCode) {
            throw error
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError.decodingFailed
        }
    }
    
    /// Request with automatic retry
    func requestWithRetry<T: Decodable>(
        _ endpoint: APIEndpoint<T>,
        maxAttempts: Int = 3
    ) async throws -> T {
        try await withRetry(maxAttempts: maxAttempts) {
            try await request(endpoint)
        }
    }
    
    /// Fire-and-forget request (e.g. analytics, status updates)
    func send(_ endpoint: APIEndpoint<EmptyResponse>) async throws {
        _ = try await request(endpoint)
    }
    
    // MARK: - Build Request
    
    private func buildRequest<T>(for endpoint: APIEndpoint<T>) async throws -> URLRequest {
        var components = URLComponents(url: baseURL.appending(path: endpoint.path), resolvingAgainstBaseURL: true)!
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw AppError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Attach body
        if let body = endpoint.body {
            request.httpBody = try encoder.encode(body)
        }
        
        // Attach auth token
        if endpoint.requiresAuth, let authManager {
            try await request.authenticate(with: authManager)
        }
        
        return request
    }
}

/// Placeholder for endpoints that return no meaningful body
struct EmptyResponse: Decodable {}

// MARK: - Convenience: Define Endpoints

struct StatusUpdateBody: Encodable {
    let status: String
}

/// Group related endpoints together
enum OrderEndpoints {
    static func list(page: Int = 1, pageSize: Int = 20) -> APIEndpoint<[APIOrder]> {
        APIEndpoint(
            path: "/orders",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "page_size", value: "\(pageSize)")
            ]
        )
    }
    
    static func detail(id: String) -> APIEndpoint<APIOrder> {
        APIEndpoint(path: "/orders/\(id)")
    }
    
    static func updateStatus(id: String, status: String) -> APIEndpoint<APIOrder> {
        APIEndpoint(
            path: "/orders/\(id)/status",
            method: .patch,
            body: StatusUpdateBody(status: status)
        )
    }
}

struct APIOrder: Codable, Identifiable {
    let id: String
    let customerName: String
    let address: String
    let status: String
    let createdAt: Date?
}

// MARK: - Usage Example

struct APIClientUsageExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("APIClient Usage")
                .font(.headline)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Text("See code comments for real usage patterns")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

/*
 // Setup in App:
 
 let apiClient = APIClient(
     baseURL: URL(string: "https://api.bidone.co.nz/v1")!,
     authManager: authManager
 )
 
 // In a ViewModel:
 
 func loadOrders() async {
     state = .loading
     do {
         let orders = try await apiClient.requestWithRetry(
             OrderEndpoints.list(page: 1)
         )
         state = orders.isEmpty ? .empty : .loaded(orders)
     } catch {
         state = .error(AppError.from(error).localizedDescription)
     }
 }
 
 func markDelivered(orderId: String) async {
     do {
         let updated = try await apiClient.request(
             OrderEndpoints.updateStatus(id: orderId, status: "delivered")
         )
         // update local state...
     } catch {
         errorMessage = AppError.from(error).localizedDescription
     }
 }
 */

// MARK: - Preview

#Preview("API Client Usage") {
    APIClientUsageExample()
}
