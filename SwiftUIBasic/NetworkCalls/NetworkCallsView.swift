//
//  NetworkCallsView.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/10/4.
//

import SwiftUI

struct GithubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GithubError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct NetworkCallsView: View {
    @State private var user: GithubUser?
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
            }
            .frame(width: 120, height: 120)
            
            Text(user?.login ?? "Login Placeholder")
                .bold()
                .font(.title3)
            
            Text(user?.bio ?? "Bio Placeholder")
                .padding()
            
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch GithubError.invalidURL {
                print("invalidURL")
            } catch GithubError.invalidResponse {
                print("invalidResponse")
            } catch GithubError.invalidData {
                print("invalidData")
            } catch {
                print("unknown error \(error.localizedDescription)")
            }
        }
    }
    
    func getUser() async throws -> GithubUser {
        let urlString = "https://api.github.com/users/twostraws"
        guard let url = URL(string: urlString) else {
            throw GithubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GithubError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            throw GithubError.invalidData
        }
    }
    
    func fetchData<T: Decodable>(for: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}

#Preview {
    NetworkCallsView()
}
