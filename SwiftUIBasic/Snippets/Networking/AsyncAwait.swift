//
//  AsyncAwait.swift
//  SwiftUIBasic
//
//  Async/await, URLSession, Task, and error handling
//

import SwiftUI

// MARK: - Basic Async/Await

struct BasicAsyncAwaitExample: View {
    @State private var message = "Tap to load"
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic Async/Await")
                .font(.headline)
            
            if isLoading {
                ProgressView()
            } else {
                Text(message)
            }
            
            Button("Load Data") {
                // Task creates async context from sync code
                Task {
                    await loadData()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func loadData() async {
        isLoading = true
        
        // Simulate network delay
        try? await Task.sleep(for: .seconds(2))
        
        message = "Data loaded at \(Date.now.formatted(date: .omitted, time: .standard))"
        isLoading = false
    }
}

// MARK: - Fetch JSON from API

struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String?
    let publicRepos: Int
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidData:
            return "Could not decode data"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        }
    }
}

struct FetchJSONExample: View {
    @State private var user: GitHubUser?
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Fetch JSON")
                .font(.headline)
            
            if isLoading {
                ProgressView("Loading...")
            } else if let user {
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: user.avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    Text(user.login)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(user.bio ?? "No bio")
                        .foregroundStyle(.secondary)
                    
                    Text("Repos: \(user.publicRepos)")
                }
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button("Fetch User") {
                Task {
                    await fetchUser()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func fetchUser() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await getUser(username: "twostraws")
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func getUser(username: String) async throws -> GitHubUser {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
}

// MARK: - Using .task Modifier

struct TaskModifierExample: View {
    @State private var posts: [Post] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading posts...")
                } else {
                    List(posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .navigationTitle("Posts")
        }
        // .task automatically cancels when view disappears
        .task {
            await loadPosts()
        }
    }
    
    private func loadPosts() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            posts = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            print("Failed to load posts: \(error)")
        }
        
        isLoading = false
    }
}

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

// MARK: - Task Cancellation

struct TaskCancellationExample: View {
    @State private var message = "Tap to start"
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Task Cancellation")
                .font(.headline)
            
            Text(message)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            HStack {
                Button("Start Task") {
                    startTask()
                }
                
                Button("Cancel") {
                    cancelTask()
                }
                .foregroundStyle(.red)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func startTask() {
        // Cancel existing task if any
        currentTask?.cancel()
        
        currentTask = Task {
            for i in 1...10 {
                // Check for cancellation
                if Task.isCancelled {
                    message = "Task cancelled at step \(i)"
                    return
                }
                
                message = "Step \(i) of 10..."
                try? await Task.sleep(for: .seconds(1))
            }
            
            message = "Task completed!"
        }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
    }
}

// MARK: - Task Result Handling

struct TaskResultExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Task Result")
                .font(.headline)
            
            Button("Fetch with Result") {
                Task {
                    await fetchWithResult()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func fetchWithResult() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            struct Todo: Codable {
                let title: String
            }
            
            let todo = try JSONDecoder().decode(Todo.self, from: data)
            return todo.title
        }
        
        // Get the result
        let result = await fetchTask.result
        
        switch result {
        case .success(let title):
            output = "Success: \(title)"
        case .failure(let error):
            output = "Error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Parallel Async Calls

struct ParallelAsyncExample: View {
    @State private var results: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parallel Async Calls")
                .font(.headline)
            
            if isLoading {
                ProgressView("Loading 3 requests in parallel...")
            } else {
                ForEach(results, id: \.self) { result in
                    Text(result)
                }
            }
            
            Button("Fetch All") {
                Task {
                    await fetchAll()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func fetchAll() async {
        isLoading = true
        results = []
        
        // Run multiple requests in parallel using async let
        async let user1 = fetchUserName(id: 1)
        async let user2 = fetchUserName(id: 2)
        async let user3 = fetchUserName(id: 3)
        
        // Wait for all results
        let names = await [user1, user2, user3]
        results = names
        
        isLoading = false
    }
    
    private func fetchUserName(id: Int) async -> String {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)") else {
            return "Invalid URL"
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            struct User: Codable {
                let name: String
            }
            
            let user = try JSONDecoder().decode(User.self, from: data)
            return "User \(id): \(user.name)"
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}

// MARK: - TaskGroup

struct TaskGroupExample: View {
    @State private var images: [Int: UIImage] = [:]
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TaskGroup")
                .font(.headline)
            
            if isLoading {
                ProgressView("Loading images...")
            } else {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(Array(images.keys.sorted()), id: \.self) { key in
                        if let image = images[key] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                        }
                    }
                }
            }
            
            Button("Load Images") {
                Task {
                    await loadImages()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
    
    private func loadImages() async {
        isLoading = true
        images = [:]
        
        let imageIds = [1, 2, 3, 4, 5, 6]
        
        // Use TaskGroup to fetch multiple images concurrently
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for id in imageIds {
                group.addTask {
                    let image = await self.fetchImage(id: id)
                    return (id, image)
                }
            }
            
            // Collect results as they complete
            for await (id, image) in group {
                if let image {
                    images[id] = image
                }
            }
        }
        
        isLoading = false
    }
    
    private func fetchImage(id: Int) async -> UIImage? {
        let urlString = "https://picsum.photos/id/\(id * 10)/200"
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}

// MARK: - Generic Fetch Function

struct GenericFetchExample: View {
    @State private var todo: Todo?
    @State private var user: RemoteUser?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Generic Fetch")
                .font(.headline)
            
            if let todo {
                Text("Todo: \(todo.title)")
            }
            
            if let user {
                Text("User: \(user.name)")
            }
            
            Button("Fetch Both") {
                Task {
                    todo = try? await fetch(Todo.self, from: "https://jsonplaceholder.typicode.com/todos/1")
                    user = try? await fetch(RemoteUser.self, from: "https://jsonplaceholder.typicode.com/users/1")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func fetch<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct Todo: Codable {
    let id: Int
    let title: String
    let completed: Bool
}

struct RemoteUser: Codable {
    let id: Int
    let name: String
    let email: String
}

// MARK: - Preview

#Preview("Basic Async/Await") {
    BasicAsyncAwaitExample()
}

#Preview("Fetch JSON") {
    FetchJSONExample()
}

#Preview(".task Modifier") {
    TaskModifierExample()
}

#Preview("Task Cancellation") {
    TaskCancellationExample()
}

#Preview("Task Result") {
    TaskResultExample()
}

#Preview("Parallel Async") {
    ParallelAsyncExample()
}

#Preview("TaskGroup") {
    TaskGroupExample()
}

#Preview("Generic Fetch") {
    GenericFetchExample()
}
