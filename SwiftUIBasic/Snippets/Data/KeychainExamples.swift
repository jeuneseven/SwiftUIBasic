//
//  KeychainExamples.swift
//  SwiftUIBasic
//
//  Keychain Services for secure storage (tokens, passwords, sensitive data)
//  Use this instead of UserDefaults for anything security-sensitive
//

import SwiftUI
import Security

// MARK: - Keychain Helper

/// Lightweight Keychain wrapper, no third-party dependencies
/// Stores String values securely in the system keychain
struct KeychainHelper {
    
    static let shared = KeychainHelper()
    private init() {}
    
    /// Save a string to keychain
    func save(_ value: String, for key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        // Delete existing item first to avoid duplicates
        delete(key)
        
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String:   data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Read a string from keychain
    func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String:  true,
            kSecMatchLimit as String:  kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    /// Delete a keychain item
    @discardableResult
    func delete(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    /// Check if a key exists
    func exists(_ key: String) -> Bool {
        read(key) != nil
    }
    
    /// Save Codable object as JSON
    func save<T: Encodable>(_ object: T, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(object),
              let string = String(data: data, encoding: .utf8) else {
            return false
        }
        return save(string, for: key)
    }
    
    /// Read Codable object from JSON
    func read<T: Decodable>(_ key: String, as type: T.Type) -> T? {
        guard let string = read(key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Basic Keychain Usage

struct BasicKeychainExample: View {
    @State private var inputText = ""
    @State private var storedValue = ""
    @State private var message = ""
    
    private let keychainKey = "example_secret"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keychain Storage")
                .font(.headline)
            
            TextField("Enter secret value", text: $inputText)
                .textFieldStyle(.roundedBorder)
            
            HStack(spacing: 12) {
                Button("Save") {
                    if KeychainHelper.shared.save(inputText, for: keychainKey) {
                        message = "Saved securely"
                        inputText = ""
                    } else {
                        message = "Save failed"
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.isEmpty)
                
                Button("Read") {
                    if let value = KeychainHelper.shared.read(keychainKey) {
                        storedValue = value
                        message = "Read from keychain"
                    } else {
                        message = "No value found"
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Delete") {
                    KeychainHelper.shared.delete(keychainKey)
                    storedValue = ""
                    message = "Deleted"
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            
            if !storedValue.isEmpty {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.green)
                    Text("Stored: \(storedValue)")
                }
                .padding()
                .background(.green.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            }
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Keychain with Codable

struct StoredCredential: Codable {
    let username: String
    let token: String
    let expiresAt: Date
    
    var isExpired: Bool {
        Date.now > expiresAt
    }
}

struct CodableKeychainExample: View {
    @State private var credential: StoredCredential?
    @State private var message = ""
    
    private let key = "user_credential"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Codable Keychain")
                .font(.headline)
            
            if let credential {
                VStack(alignment: .leading, spacing: 8) {
                    Label(credential.username, systemImage: "person.fill")
                    Label("Token: \(String(credential.token.prefix(10)))...", systemImage: "key.fill")
                    Label(
                        credential.isExpired ? "Expired" : "Valid",
                        systemImage: credential.isExpired ? "xmark.circle" : "checkmark.circle"
                    )
                    .foregroundStyle(credential.isExpired ? .red : .green)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            }
            
            HStack {
                Button("Save Mock Credential") {
                    let cred = StoredCredential(
                        username: "driver@bidone.co.nz",
                        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock",
                        expiresAt: Date.now.addingTimeInterval(3600)
                    )
                    if KeychainHelper.shared.save(cred, for: key) {
                        credential = cred
                        message = "Credential saved"
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Load") {
                    credential = KeychainHelper.shared.read(key, as: StoredCredential.self)
                    message = credential != nil ? "Loaded" : "Not found"
                }
                .buttonStyle(.bordered)
            }
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Basic Keychain") {
    BasicKeychainExample()
}

#Preview("Codable Keychain") {
    CodableKeychainExample()
}
