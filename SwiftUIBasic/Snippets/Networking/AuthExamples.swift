//
//  AuthExamples.swift
//  SwiftUIBasic
//
//  Authentication management: login flow, token refresh, session handling
//  Depends on KeychainHelper from KeychainExamples.swift
//

import SwiftUI

// MARK: - Auth Token Model

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
    
    var isExpired: Bool {
        Date.now > expiresAt
    }
    
    /// Check if token expires within given seconds (for proactive refresh)
    func expiresSoon(within seconds: TimeInterval = 300) -> Bool {
        Date.now > expiresAt.addingTimeInterval(-seconds)
    }
}

// MARK: - Auth Manager

/// Centralized authentication state manager
/// Inject via .environment() at app root
@Observable
class AuthManager {
    
    private(set) var isAuthenticated = false
    private(set) var currentUser: AppUserProfile?
    private(set) var isLoading = false
    
    private let tokenKey = "auth_token"
    private let keychain = KeychainHelper.shared
    
    init() {
        // Restore session on launch
        restoreSession()
    }
    
    // MARK: - Public API
    
    /// Login with credentials, stores token in keychain
    func login(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate API call
        try await Task.sleep(for: .seconds(1.5))
        
        // In real app: POST /api/auth/login
        // let (data, response) = try await URLSession.shared.data(for: request)
        
        // Mock response
        let token = AuthToken(
            accessToken: "access_\(UUID().uuidString)",
            refreshToken: "refresh_\(UUID().uuidString)",
            expiresAt: Date.now.addingTimeInterval(3600) // 1 hour
        )
        
        let user = AppUserProfile(
            id: "U001",
            name: "Test Driver",
            email: email,
            role: .driver
        )
        
        saveToken(token)
        currentUser = user
        isAuthenticated = true
    }
    
    /// Logout, clear all stored credentials
    func logout() {
        keychain.delete(tokenKey)
        currentUser = nil
        isAuthenticated = false
    }
    
    /// Get a valid access token, refreshing if needed
    func validAccessToken() async throws -> String {
        guard let token = loadToken() else {
            throw AppError.unauthorized
        }
        
        if token.expiresSoon() {
            return try await refreshToken(token)
        }
        
        return token.accessToken
    }
    
    // MARK: - Private
    
    private func restoreSession() {
        guard let token = loadToken(), !token.isExpired else {
            logout()
            return
        }
        isAuthenticated = true
        // In real app: also restore user profile from keychain or API
    }
    
    private func refreshToken(_ token: AuthToken) async throws -> String {
        // Simulate refresh API call
        try await Task.sleep(for: .seconds(0.5))
        
        // In real app: POST /api/auth/refresh with refreshToken
        // If refresh also expired → throw .unauthorized → force re-login
        
        let newToken = AuthToken(
            accessToken: "access_\(UUID().uuidString)",
            refreshToken: token.refreshToken,
            expiresAt: Date.now.addingTimeInterval(3600)
        )
        
        saveToken(newToken)
        return newToken.accessToken
    }
    
    private func saveToken(_ token: AuthToken) {
        keychain.save(token, for: tokenKey)
    }
    
    private func loadToken() -> AuthToken? {
        keychain.read(tokenKey, as: AuthToken.self)
    }
}

// MARK: - User Profile

struct AppUserProfile: Codable {
    let id: String
    let name: String
    let email: String
    let role: UserRole
}

enum UserRole: String, Codable {
    case driver
    case dispatcher
    case admin
}

// MARK: - Auth-Gated Root View

/// App entry point that switches between login and main content
struct AuthGatedRootExample: View {
    @State private var authManager = AuthManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                AuthenticatedHomeExample()
            } else {
                LoginViewExample()
            }
        }
        .environment(authManager)
    }
}

// MARK: - Login View

struct LoginViewExample: View {
    @Environment(AuthManager.self) private var authManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Logo area
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Bidone")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                }
                .padding(.horizontal)
                
                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
                
                Button {
                    Task { await login() }
                } label: {
                    if authManager.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                
                Spacer()
                Spacer()
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func login() async {
        errorMessage = nil
        do {
            try await authManager.login(email: email, password: password)
        } catch {
            errorMessage = AppError.from(error).localizedDescription
        }
    }
}

// MARK: - Authenticated Home

struct AuthenticatedHomeExample: View {
    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        NavigationStack {
            List {
                if let user = authManager.currentUser {
                    Section {
                        Label(user.name, systemImage: "person.fill")
                        Label(user.email, systemImage: "envelope")
                        Label(user.role.rawValue.capitalized, systemImage: "briefcase")
                    } header: {
                        Text("Profile")
                    }
                }
                
                Section {
                    Label("Today's Deliveries", systemImage: "truck.box")
                    Label("Route Map", systemImage: "map")
                    Label("Scan & Sign", systemImage: "barcode.viewfinder")
                }
                
                Section {
                    Button(role: .destructive) {
                        authManager.logout()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Bidone")
        }
    }
}

// MARK: - Authenticated URLRequest Helper

/// Extension to inject auth token into any URLRequest
extension URLRequest {
    /// Adds Bearer token to request, refreshing if needed
    mutating func authenticate(with authManager: AuthManager) async throws {
        let token = try await authManager.validAccessToken()
        setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

struct AuthenticatedRequestExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Authenticated Request")
                .font(.headline)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Text("Shows how to attach Bearer token to API calls")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

/*
 // Usage in a real ViewModel:
 
 func fetchOrders() async throws -> [Order] {
     var request = URLRequest(url: URL(string: "https://api.bidone.co.nz/orders")!)
     try await request.authenticate(with: authManager)
     
     let (data, response) = try await URLSession.shared.data(for: request)
     
     guard let http = response as? HTTPURLResponse else {
         throw AppError.invalidResponse
     }
     
     if let error = AppError.fromStatusCode(http.statusCode) {
         throw error
     }
     
     return try JSONDecoder().decode([Order].self, from: data)
 }
 */

// MARK: - Preview

#Preview("Auth Gated Root") {
    AuthGatedRootExample()
}

#Preview("Login") {
    LoginViewExample()
        .environment(AuthManager())
}

#Preview("Authenticated Home") {
    AuthenticatedHomeExample()
        .environment(AuthManager())
}
