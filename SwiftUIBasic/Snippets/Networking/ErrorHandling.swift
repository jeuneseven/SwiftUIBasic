//
//  ErrorHandling.swift
//  SwiftUIBasic
//
//  Unified error handling, retry logic, and network error patterns
//

import SwiftUI

// MARK: - App-Wide Error Type

/// Unified error type covering common failure scenarios in a delivery app
enum AppError: Error, LocalizedError {
    case networkUnavailable
    case timeout
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case unauthorized        // 401 - token expired
    case forbidden           // 403 - no permission
    case notFound            // 404
    case decodingFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .serverError(let code):
            return "Server error (\(code))"
        case .unauthorized:
            return "Session expired, please log in again"
        case .forbidden:
            return "You don't have permission to do this"
        case .notFound:
            return "The requested resource was not found"
        case .decodingFailed:
            return "Failed to process server response"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    /// Whether user can retry this error
    var isRetryable: Bool {
        switch self {
        case .networkUnavailable, .timeout, .serverError:
            return true
        case .invalidURL, .invalidResponse, .unauthorized, .forbidden, .notFound, .decodingFailed, .unknown:
            return false
        }
    }
    
    /// Map from HTTP status code
    static func fromStatusCode(_ code: Int) -> AppError? {
        switch code {
        case 200...299: return nil // success
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 500...599: return .serverError(statusCode: code)
        default: return .serverError(statusCode: code)
        }
    }
    
    /// Map from any Error (e.g. URLSession errors)
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        let nsError = error as NSError
        
        // URLError codes
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorDataNotAllowed:
                return .networkUnavailable
            case NSURLErrorTimedOut:
                return .timeout
            default:
                return .unknown(error)
            }
        }
        
        // Decoding errors
        if error is DecodingError {
            return .decodingFailed
        }
        
        return .unknown(error)
    }
}

// MARK: - Retry Logic

/// Performs an async operation with exponential backoff retry
/// - Parameters:
///   - maxAttempts: Maximum number of attempts (default: 3)
///   - initialDelay: First retry delay in seconds (default: 1.0)
///   - multiplier: Delay multiplier per attempt (default: 2.0)
///   - operation: The async throwing operation
/// - Returns: The result of the operation
func withRetry<T>(
    maxAttempts: Int = 3,
    initialDelay: Double = 1.0,
    multiplier: Double = 2.0,
    operation: () async throws -> T
) async throws -> T {
    var lastError: Error?
    var delay = initialDelay
    
    for attempt in 1...maxAttempts {
        do {
            return try await operation()
        } catch {
            lastError = error
            
            let appError = AppError.from(error)
            
            // Don't retry non-retryable errors
            guard appError.isRetryable else { throw appError }
            
            // Don't wait after last attempt
            guard attempt < maxAttempts else { break }
            
            // Exponential backoff with jitter
            let jitter = Double.random(in: 0...0.5)
            try? await Task.sleep(for: .seconds(delay + jitter))
            delay *= multiplier
        }
    }
    
    throw AppError.from(lastError!)
}

struct RetryExample: View {
    @State private var message = "Tap to fetch"
    @State private var attempts = 0
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Retry with Backoff")
                .font(.headline)
            
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Attempt \(attempts)...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(message)
            }
            
            Button("Fetch") {
                Task { await fetchWithRetry() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func fetchWithRetry() async {
        isLoading = true
        attempts = 0
        
        do {
            let result: String = try await withRetry(maxAttempts: 3) {
                attempts += 1
                
                // Simulate flaky network - fails first 2 times
                if attempts < 3 {
                    throw URLError(.timedOut)
                }
                return "Success on attempt \(attempts)"
            }
            message = result
        } catch {
            message = AppError.from(error).localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - Safe API Call Wrapper

/// Wraps a network call, maps errors to AppError, returns Result
func safeAPICall<T>(_ operation: () async throws -> T) async -> Result<T, AppError> {
    do {
        let result = try await operation()
        return .success(result)
    } catch {
        return .failure(AppError.from(error))
    }
}

struct SafeAPICallExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Safe API Call")
                .font(.headline)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            HStack {
                Button("Success") {
                    Task { await callAPI(shouldFail: false) }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Failure") {
                    Task { await callAPI(shouldFail: true) }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func callAPI(shouldFail: Bool) async {
        let result = await safeAPICall {
            if shouldFail {
                throw URLError(.notConnectedToInternet)
            }
            return "Order #1001 fetched"
        }
        
        switch result {
        case .success(let data):
            output = "✅ \(data)"
        case .failure(let error):
            output = "❌ \(error.localizedDescription)\nRetryable: \(error.isRetryable)"
        }
    }
}

// MARK: - Error Banner View

/// A reusable error banner that slides in from the top
struct ErrorBanner: View {
    let error: AppError
    var retryAction: (() -> Void)?
    var dismissAction: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                if error.isRetryable {
                    Text("Tap retry to try again")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            if error.isRetryable, let retryAction {
                Button("Retry", action: retryAction)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            if let dismissAction {
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding()
        .background(.red.gradient)
        .clipShape(.rect(cornerRadius: 12))
        .padding(.horizontal)
    }
}

struct ErrorBannerExample: View {
    @State private var currentError: AppError?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Error Banner")
                .font(.headline)
            
            if let error = currentError {
                ErrorBanner(
                    error: error,
                    retryAction: {
                        currentError = nil
                    },
                    dismissAction: {
                        withAnimation { currentError = nil }
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button("Network Error") {
                    withAnimation { currentError = .networkUnavailable }
                }
                Button("Auth Error") {
                    withAnimation { currentError = .unauthorized }
                }
                Button("Server Error") {
                    withAnimation { currentError = .serverError(statusCode: 500) }
                }
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Combine with ViewState

/// Shows how ErrorHandling integrates with ViewStateExample
@Observable
class OrderListModel {
    var state: ViewStateExample<[String]> = .idle
    
    func loadOrders() async {
        state = .loading
        
        do {
            let orders: [String] = try await withRetry(maxAttempts: 2) {
                // Real app: URLSession call here
                try await Task.sleep(for: .seconds(1))
                
                // Simulate random failure
                if Bool.random() {
                    throw URLError(.timedOut)
                }
                return ["Order #4001", "Order #4002", "Order #4003"]
            }
            
            state = orders.isEmpty ? .empty : .loaded(orders)
        } catch {
            let appError = AppError.from(error)
            state = .error(appError.localizedDescription)
        }
    }
}

struct ErrorWithViewStateExample: View {
    @State private var model = OrderListModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch model.state {
                case .idle:
                    Color.clear
                case .loading:
                    ProgressView("Loading orders...")
                case .loaded(let orders):
                    List(orders, id: \.self) { order in
                        Label(order, systemImage: "shippingbox")
                    }
                case .empty:
                    ContentUnavailableView("No Orders", systemImage: "tray")
                case .error(let message):
                    ContentUnavailableView {
                        Label("Error", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            Task { await model.loadOrders() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Orders")
        }
        .task {
            await model.loadOrders()
        }
    }
}

// MARK: - Preview

#Preview("Retry") {
    RetryExample()
}

#Preview("Safe API Call") {
    SafeAPICallExample()
}

#Preview("Error Banner") {
    ErrorBannerExample()
}

#Preview("With ViewState") {
    ErrorWithViewStateExample()
}
