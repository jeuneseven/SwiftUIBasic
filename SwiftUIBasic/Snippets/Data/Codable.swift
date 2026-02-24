//
//  Codable.swift
//  SwiftUIBasic
//
//  JSON encoding/decoding, Codable protocol, and custom coding
//

import SwiftUI

// MARK: - Basic Codable Struct

struct Employee: Codable {
    var name: String
    var age: Int
    var email: String
}

struct BasicCodableExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic Codable")
                .font(.headline)
            
            Button("Encode & Decode") {
                encodeAndDecode()
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 200)
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func encodeAndDecode() {
        let employee = Employee(name: "John", age: 30, email: "john@example.com")
        
        // Encode to JSON
        guard let jsonData = try? JSONEncoder().encode(employee) else {
            output = "Encoding failed"
            return
        }
        
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        
        // Decode from JSON
        guard let decoded = try? JSONDecoder().decode(Employee.self, from: jsonData) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        Original: \(employee)
        
        JSON:
        \(jsonString)
        
        Decoded: \(decoded)
        """
    }
}

// MARK: - Custom Coding Keys

struct Product: Codable {
    var id: Int
    var productName: String
    var priceUSD: Double
    var isAvailable: Bool
    
    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case priceUSD = "price_usd"
        case isAvailable = "is_available"
    }
}

struct CodingKeysExample: View {
    @State private var output = ""
    
    let jsonString = """
    {
        "id": 1,
        "product_name": "MacBook Pro",
        "price_usd": 1999.99,
        "is_available": true
    }
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Coding Keys")
                .font(.headline)
            
            Text("JSON uses snake_case, Swift uses camelCase")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Decode") {
                decodeProduct()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func decodeProduct() {
        let data = Data(jsonString.utf8)
        
        guard let product = try? JSONDecoder().decode(Product.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        ID: \(product.id)
        Name: \(product.productName)
        Price: $\(product.priceUSD)
        Available: \(product.isAvailable)
        """
    }
}

// MARK: - Snake Case Strategy (Automatic)

struct Article: Codable {
    var articleId: Int
    var articleTitle: String
    var publishedDate: String
    var authorName: String
}

struct SnakeCaseStrategyExample: View {
    @State private var output = ""
    
    let jsonString = """
    {
        "article_id": 42,
        "article_title": "SwiftUI Guide",
        "published_date": "2024-01-15",
        "author_name": "Swift Developer"
    }
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Snake Case Strategy")
                .font(.headline)
            
            Text("Automatically converts snake_case to camelCase")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Decode") {
                decodeArticle()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func decodeArticle() {
        let data = Data(jsonString.utf8)
        
        let decoder = JSONDecoder()
        // Automatically convert snake_case to camelCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let article = try? decoder.decode(Article.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        ID: \(article.articleId)
        Title: \(article.articleTitle)
        Date: \(article.publishedDate)
        Author: \(article.authorName)
        """
    }
}

// MARK: - Nested JSON

struct APIResponse: Codable {
    var status: String
    var data: ResponseData
    
    struct ResponseData: Codable {
        var user: UserInfo
        var settings: Settings
    }
    
    struct UserInfo: Codable {
        var id: Int
        var username: String
    }
    
    struct Settings: Codable {
        var theme: String
        var notifications: Bool
    }
}

struct NestedJSONExample: View {
    @State private var output = ""
    
    let jsonString = """
    {
        "status": "success",
        "data": {
            "user": {
                "id": 123,
                "username": "swiftdev"
            },
            "settings": {
                "theme": "dark",
                "notifications": true
            }
        }
    }
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Nested JSON")
                .font(.headline)
            
            Button("Decode") {
                decodeNested()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func decodeNested() {
        let data = Data(jsonString.utf8)
        
        guard let response = try? JSONDecoder().decode(APIResponse.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        Status: \(response.status)
        User ID: \(response.data.user.id)
        Username: \(response.data.user.username)
        Theme: \(response.data.settings.theme)
        Notifications: \(response.data.settings.notifications)
        """
    }
}

// MARK: - Array of Objects

struct Comment: Codable, Identifiable {
    var id: Int
    var text: String
    var author: String
}

struct ArrayDecodingExample: View {
    @State private var comments: [Comment] = []
    
    let jsonString = """
    [
        {"id": 1, "text": "Great article!", "author": "Alice"},
        {"id": 2, "text": "Very helpful", "author": "Bob"},
        {"id": 3, "text": "Thanks for sharing", "author": "Charlie"}
    ]
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Array Decoding")
                .font(.headline)
            
            Button("Decode Array") {
                decodeArray()
            }
            .buttonStyle(.borderedProminent)
            
            List(comments) { comment in
                VStack(alignment: .leading) {
                    Text(comment.text)
                        .font(.body)
                    Text("by \(comment.author)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
    
    private func decodeArray() {
        let data = Data(jsonString.utf8)
        
        guard let decoded = try? JSONDecoder().decode([Comment].self, from: data) else {
            return
        }
        
        comments = decoded
    }
}

// MARK: - Date Decoding

struct Event: Codable {
    var name: String
    var date: Date
}

struct DateDecodingExample: View {
    @State private var output = ""
    
    // ISO 8601 format
    let jsonISO = """
    {"name": "Conference", "date": "2024-06-15T09:00:00Z"}
    """
    
    // Unix timestamp
    let jsonUnix = """
    {"name": "Meeting", "date": 1718438400}
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Date Decoding")
                .font(.headline)
            
            HStack {
                Button("ISO 8601") {
                    decodeISO()
                }
                
                Button("Unix Timestamp") {
                    decodeUnix()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func decodeISO() {
        let data = Data(jsonISO.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let event = try? decoder.decode(Event.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        Name: \(event.name)
        Date: \(event.date.formatted())
        """
    }
    
    private func decodeUnix() {
        let data = Data(jsonUnix.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        guard let event = try? decoder.decode(Event.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        Name: \(event.name)
        Date: \(event.date.formatted())
        """
    }
}

// MARK: - Optional and Default Values

struct UserProfile: Codable {
    var name: String
    var bio: String?  // Optional field
    var followerCount: Int
    var isVerified: Bool
    
    // Provide defaults for missing keys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount) ?? 0
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified) ?? false
    }
}

struct OptionalValuesExample: View {
    @State private var output = ""
    
    // JSON with missing fields
    let jsonString = """
    {"name": "SwiftDev"}
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Optional & Default Values")
                .font(.headline)
            
            Text("JSON only has 'name', other fields use defaults")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Decode") {
                decodeProfile()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func decodeProfile() {
        let data = Data(jsonString.utf8)
        
        guard let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            output = "Decoding failed"
            return
        }
        
        output = """
        Name: \(profile.name)
        Bio: \(profile.bio ?? "nil")
        Followers: \(profile.followerCount)
        Verified: \(profile.isVerified)
        """
    }
}

// MARK: - Codable with @Observable

import Observation

@Observable
class ObservablePlayer: Codable {
    var name: String = ""
    var score: Int = 0
    
    // Required for @Observable + Codable
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _score = "score"
    }
}

struct ObservableCodableExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("@Observable + Codable")
                .font(.headline)
            
            Text("Use _propertyName in CodingKeys")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Encode") {
                encodeObservable()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func encodeObservable() {
        let player = ObservablePlayer()
        player.name = "Swift"
        player.score = 100
        
        guard let data = try? JSONEncoder().encode(player) else {
            output = "Encoding failed"
            return
        }
        
        output = String(decoding: data, as: UTF8.self)
    }
}

// MARK: - Bundle Extension for JSON Files

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(file): \(error)")
        }
    }
}

// Usage: let users: [User] = Bundle.main.decode("users.json")

// MARK: - Preview

#Preview("Basic Codable") {
    BasicCodableExample()
}

#Preview("Coding Keys") {
    CodingKeysExample()
}

#Preview("Snake Case") {
    SnakeCaseStrategyExample()
}

#Preview("Nested JSON") {
    NestedJSONExample()
}

#Preview("Array Decoding") {
    ArrayDecodingExample()
}

#Preview("Date Decoding") {
    DateDecodingExample()
}

#Preview("Optional Values") {
    OptionalValuesExample()
}

#Preview("Observable Codable") {
    ObservableCodableExample()
}
