//
//  Biometrics.swift
//  SwiftUIBasic
//
//  Face ID, Touch ID authentication using LocalAuthentication
//  Requires NSFaceIDUsageDescription in Info.plist
//

import SwiftUI
import LocalAuthentication

// MARK: - Basic Biometric Authentication

struct BasicBiometricsExample: View {
    @State private var isUnlocked = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Biometric Authentication")
                .font(.headline)
            
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .font(.system(size: 60))
                .foregroundStyle(isUnlocked ? .green : .red)
            
            Text(isUnlocked ? "Unlocked" : "Locked")
                .font(.title2)
                .fontWeight(.semibold)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(isUnlocked ? "Lock" : "Unlock with Biometrics") {
                if isUnlocked {
                    isUnlocked = false
                } else {
                    authenticate()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometrics is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock to access your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        errorMessage = ""
                    } else {
                        errorMessage = authError?.localizedDescription ?? "Authentication failed"
                    }
                }
            }
        } else {
            // Biometrics not available
            errorMessage = error?.localizedDescription ?? "Biometrics not available"
        }
    }
}

// MARK: - Biometric Type Detection

struct BiometricTypeExample: View {
    @State private var biometricType = ""
    @State private var biometricIcon = "faceid"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Biometric Type Detection")
                .font(.headline)
            
            Image(systemName: biometricIcon)
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text(biometricType)
                .font(.title3)
            
            Button("Detect Biometric Type") {
                detectBiometricType()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            detectBiometricType()
        }
    }
    
    private func detectBiometricType() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                biometricType = "Face ID Available"
                biometricIcon = "faceid"
            case .touchID:
                biometricType = "Touch ID Available"
                biometricIcon = "touchid"
            case .opticID:
                biometricType = "Optic ID Available"
                biometricIcon = "opticid"
            case .none:
                biometricType = "No Biometrics"
                biometricIcon = "xmark.circle"
            @unknown default:
                biometricType = "Unknown Biometric Type"
                biometricIcon = "questionmark.circle"
            }
        } else {
            biometricType = "Biometrics Not Available"
            biometricIcon = "xmark.circle"
        }
    }
}

// MARK: - Device Passcode Fallback

struct PasscodeFallbackExample: View {
    @State private var isAuthenticated = false
    @State private var statusMessage = "Not authenticated"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Passcode Fallback")
                .font(.headline)
            
            Image(systemName: isAuthenticated ? "checkmark.shield.fill" : "shield")
                .font(.system(size: 60))
                .foregroundStyle(isAuthenticated ? .green : .gray)
            
            Text(statusMessage)
                .font(.body)
                .multilineTextAlignment(.center)
            
            Button("Authenticate") {
                authenticateWithPasscodeFallback()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isAuthenticated)
            
            Text("Falls back to device passcode if biometrics fail")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private func authenticateWithPasscodeFallback() {
        let context = LAContext()
        var error: NSError?
        
        // deviceOwnerAuthentication allows passcode as fallback
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to continue"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                        statusMessage = "Authentication successful!"
                    } else {
                        statusMessage = authError?.localizedDescription ?? "Authentication failed"
                    }
                }
            }
        } else {
            statusMessage = error?.localizedDescription ?? "Authentication not available"
        }
    }
}

// MARK: - Protected Content View

struct ProtectedContentExample: View {
    @State private var isUnlocked = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isUnlocked {
                    ProtectedDataView(isUnlocked: $isUnlocked)
                } else {
                    LockedView(isUnlocked: $isUnlocked)
                }
            }
            .navigationTitle("Secure Notes")
        }
    }
}

struct LockedView: View {
    @Binding var isUnlocked: Bool
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Content Protected")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Authenticate to view your secure notes")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            Button {
                authenticate()
            } label: {
                Label("Unlock", systemImage: "faceid")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access your secure notes") { success, _ in
                DispatchQueue.main.async {
                    if success {
                        withAnimation {
                            isUnlocked = true
                        }
                    } else {
                        errorMessage = "Authentication failed. Try again."
                    }
                }
            }
        } else {
            errorMessage = "Biometrics not available"
        }
    }
}

struct ProtectedDataView: View {
    @Binding var isUnlocked: Bool
    
    let notes = [
        "Bank account: 1234-5678",
        "Safe combination: 42-15-33",
        "Secret recipe ingredient: love"
    ]
    
    var body: some View {
        List {
            Section("Secure Notes") {
                ForEach(notes, id: \.self) { note in
                    HStack {
                        Image(systemName: "lock.open")
                            .foregroundStyle(.green)
                        Text(note)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        isUnlocked = false
                    }
                } label: {
                    Image(systemName: "lock")
                }
            }
        }
    }
}

// MARK: - Biometric Auth Manager

class BiometricAuthManager {
    enum AuthError: Error, LocalizedError {
        case notAvailable
        case notEnrolled
        case lockout
        case cancelled
        case failed(String)
        
        var errorDescription: String? {
            switch self {
            case .notAvailable:
                return "Biometric authentication is not available on this device"
            case .notEnrolled:
                return "No biometric data enrolled. Please set up Face ID or Touch ID in Settings."
            case .lockout:
                return "Biometric authentication is locked. Please use your passcode."
            case .cancelled:
                return "Authentication was cancelled"
            case .failed(let message):
                return message
            }
        }
    }
    
    static func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let laError = error as? LAError {
                switch laError.code {
                case .biometryNotAvailable:
                    throw AuthError.notAvailable
                case .biometryNotEnrolled:
                    throw AuthError.notEnrolled
                case .biometryLockout:
                    throw AuthError.lockout
                default:
                    throw AuthError.failed(laError.localizedDescription)
                }
            }
            throw AuthError.notAvailable
        }
        
        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        } catch let error as LAError {
            switch error.code {
            case .userCancel, .appCancel, .systemCancel:
                throw AuthError.cancelled
            default:
                throw AuthError.failed(error.localizedDescription)
            }
        }
    }
    
    static var biometryType: LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    static var biometryName: String {
        switch biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        case .none: return "Passcode"
        @unknown default: return "Biometrics"
        }
    }
    
    static var biometryIcon: String {
        switch biometryType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .opticID: return "opticid"
        case .none: return "lock"
        @unknown default: return "lock"
        }
    }
}

struct BiometricManagerExample: View {
    @State private var isAuthenticated = false
    @State private var errorMessage = ""
    @State private var isAuthenticating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Biometric Manager")
                .font(.headline)
            
            Image(systemName: BiometricAuthManager.biometryIcon)
                .font(.system(size: 60))
                .foregroundStyle(isAuthenticated ? .green : .blue)
            
            Text(BiometricAuthManager.biometryName)
                .font(.title3)
            
            if isAuthenticated {
                Text("Authenticated!")
                    .foregroundStyle(.green)
                    .fontWeight(.semibold)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button {
                performAuthentication()
            } label: {
                if isAuthenticating {
                    ProgressView()
                        .frame(width: 100)
                } else {
                    Text(isAuthenticated ? "Re-authenticate" : "Authenticate")
                        .frame(width: 100)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isAuthenticating)
        }
        .padding()
    }
    
    private func performAuthentication() {
        isAuthenticating = true
        errorMessage = ""
        
        // Using Task for async/await
        let task = Task {
            do {
                let success = try await BiometricAuthManager.authenticate(reason: "Verify your identity")
                await MainActor.run {
                    isAuthenticated = success
                    isAuthenticating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAuthenticated = false
                    isAuthenticating = false
                }
            }
        }
        
        // Keep reference to avoid warning
        _ = task
    }
}

// MARK: - Auto-Lock on Background

struct AutoLockExample: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isUnlocked = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Auto-Lock on Background")
                .font(.headline)
            
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .font(.system(size: 60))
                .foregroundStyle(isUnlocked ? .green : .red)
            
            Text(isUnlocked ? "Unlocked" : "Locked")
                .font(.title2)
            
            if !isUnlocked {
                Button("Unlock") {
                    authenticate()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Text("App will lock when moved to background")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase != .active {
                // Lock when app goes to background or inactive
                isUnlocked = false
            }
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock app") { success, _ in
                DispatchQueue.main.async {
                    isUnlocked = success
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic Biometrics") {
    BasicBiometricsExample()
}

#Preview("Biometric Type") {
    BiometricTypeExample()
}

#Preview("Passcode Fallback") {
    PasscodeFallbackExample()
}

#Preview("Protected Content") {
    ProtectedContentExample()
}

#Preview("Biometric Manager") {
    BiometricManagerExample()
}

#Preview("Auto-Lock") {
    AutoLockExample()
}
