//
//  AsyncImage.swift
//  SwiftUIBasic
//
//  AsyncImage for loading remote images
//

import SwiftUI

// MARK: - Basic AsyncImage

struct BasicAsyncImageExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic AsyncImage")
                .font(.headline)
            
            // Simple usage - shows default placeholder while loading
            AsyncImage(url: URL(string: "https://picsum.photos/200"))
                .frame(width: 200, height: 200)
            
            Text("Default placeholder while loading")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - AsyncImage with Scale

struct AsyncImageScaleExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("AsyncImage with Scale")
                .font(.headline)
            
            // Scale parameter for high-resolution images
            AsyncImage(url: URL(string: "https://picsum.photos/400"), scale: 2)
                .frame(width: 200, height: 200)
            
            Text("scale: 2 for @2x images")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - AsyncImage with Custom Placeholder

struct AsyncImagePlaceholderExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Placeholder")
                .font(.headline)
            
            AsyncImage(url: URL(string: "https://picsum.photos/300")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .scaleEffect(1.5)
            }
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

// MARK: - AsyncImage with Phase Handling

struct AsyncImagePhaseExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Phase Handling")
                .font(.headline)
            
            AsyncImage(url: URL(string: "https://picsum.photos/250")) { phase in
                switch phase {
                case .empty:
                    // Loading state
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    
                case .success(let image):
                    // Image loaded successfully
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity.combined(with: .scale))
                    
                case .failure(let error):
                    // Error state
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text("Failed to load")
                            .font(.caption)
                        Text(error.localizedDescription)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

// MARK: - AsyncImage with Error Handling

struct AsyncImageErrorExample: View {
    // Invalid URL to demonstrate error state
    let invalidURL = URL(string: "https://invalid-domain-12345.com/image.jpg")
    let validURL = URL(string: "https://picsum.photos/200")
    
    @State private var useValidURL = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Error Handling")
                .font(.headline)
            
            AsyncImage(url: useValidURL ? validURL : invalidURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    VStack(spacing: 8) {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                        Text("Image unavailable")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)
            .background(Color.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            
            Toggle("Use Valid URL", isOn: $useValidURL)
                .padding(.horizontal)
        }
    }
}

// MARK: - AsyncImage in List

struct AsyncImageListExample: View {
    let imageIds = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    var body: some View {
        NavigationStack {
            List(imageIds, id: \.self) { imageId in
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: "https://picsum.photos/id/\(imageId)/100")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(.rect(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text("Image #\(imageId)")
                            .font(.headline)
                        Text("picsum.photos/id/\(imageId)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Image List")
        }
    }
}

// MARK: - AsyncImage Grid

struct AsyncImageGridExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(1...30, id: \.self) { index in
                        AsyncImage(url: URL(string: "https://picsum.photos/id/\(index * 5)/200")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if phase.error != nil {
                                Color.gray.opacity(0.3)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundStyle(.gray)
                                    }
                            } else {
                                Color.gray.opacity(0.1)
                                    .overlay {
                                        ProgressView()
                                    }
                            }
                        }
                        .frame(height: 120)
                        .clipped()
                    }
                }
            }
            .navigationTitle("Photo Grid")
        }
    }
}

// MARK: - AsyncImage with Animation

struct AsyncImageAnimationExample: View {
    @State private var imageId = 1
    
    var body: some View {
        VStack(spacing: 20) {
            Text("With Animation")
                .font(.headline)
            
            AsyncImage(url: URL(string: "https://picsum.photos/id/\(imageId)/300")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 250, height: 250)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(.rect(cornerRadius: 16))
                        .transition(.opacity.animation(.easeIn(duration: 0.3)))
                    
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .frame(width: 250, height: 250)
                    
                @unknown default:
                    EmptyView()
                }
            }
            .id(imageId) // Force refresh when ID changes
            
            Button("Load Random Image") {
                imageId = Int.random(in: 1...100)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Reusable Remote Image View

struct RemoteImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 0
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                
            case .failure:
                ZStack {
                    Color.gray.opacity(0.1)
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                }
                
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

struct ReusableRemoteImageExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Reusable Component")
                .font(.headline)
            
            RemoteImage(
                url: URL(string: "https://picsum.photos/300"),
                contentMode: .fill,
                cornerRadius: 16
            )
            .frame(width: 200, height: 200)
            
            RemoteImage(
                url: URL(string: "https://picsum.photos/400/200"),
                contentMode: .fit,
                cornerRadius: 8
            )
            .frame(width: 300, height: 150)
            .background(Color.gray.opacity(0.1))
        }
    }
}

// MARK: - AsyncImage with Cache Note

struct AsyncImageCacheNoteExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Cache Behavior")
                .font(.headline)
            
            AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Note:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text("AsyncImage uses URLSession's default cache. For custom caching, use URLSession with URLCache configuration or a third-party library.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicAsyncImageExample()
}

#Preview("Scale") {
    AsyncImageScaleExample()
}

#Preview("Placeholder") {
    AsyncImagePlaceholderExample()
}

#Preview("Phase Handling") {
    AsyncImagePhaseExample()
}

#Preview("Error Handling") {
    AsyncImageErrorExample()
}

#Preview("In List") {
    AsyncImageListExample()
}

#Preview("Grid") {
    AsyncImageGridExample()
}

#Preview("Animation") {
    AsyncImageAnimationExample()
}

#Preview("Reusable Component") {
    ReusableRemoteImageExample()
}

#Preview("Cache Note") {
    AsyncImageCacheNoteExample()
}
