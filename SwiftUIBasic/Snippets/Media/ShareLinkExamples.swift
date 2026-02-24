//
//  ShareLink.swift
//  SwiftUIBasic
//
//  ShareLink for sharing content
//

import SwiftUI
import PhotosUI

// MARK: - Basic ShareLink

struct BasicShareLinkExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic ShareLink")
                .font(.headline)
            
            // Share a URL
            ShareLink(item: URL(string: "https://www.apple.com")!) {
                Label("Share Website", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
            
            // Share text
            ShareLink(item: "Hello from SwiftUI!") {
                Label("Share Text", systemImage: "text.bubble")
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - ShareLink with Subject and Message

struct ShareLinkWithMetadataExample: View {
    let url = URL(string: "https://developer.apple.com/swift/")!
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ShareLink with Metadata")
                .font(.headline)
            
            ShareLink(
                item: url,
                subject: Text("Learn Swift"),
                message: Text("Check out the official Swift programming language!")
            ) {
                Label("Share with Message", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
            
            Text("Subject and message appear in some share targets like email")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

// MARK: - ShareLink with Preview

struct ShareLinkPreviewExample: View {
    let url = URL(string: "https://www.apple.com")!
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ShareLink with Preview")
                .font(.headline)
            
            // Custom preview with title and icon
            ShareLink(
                item: url,
                preview: SharePreview(
                    "Apple Website",
                    image: Image(systemName: "apple.logo")
                )
            ) {
                Label("Share with Preview", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
            
            Text("Preview customizes how the shared item appears")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Share Image

struct ShareImageExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var imageData: Data?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share Image")
                .font(.headline)
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
                
                if let imageData {
                    let transferable = ShareableImageData(data: imageData)
                    ShareLink(
                        item: transferable,
                        preview: SharePreview("Shared Image", image: selectedImage)
                    ) {
                        Label("Share Image", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("Select an image to share")
                            .foregroundStyle(.secondary)
                    }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(from: newItem)
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                imageData = uiImage.pngData()
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }
}

// Custom Transferable for image data
struct ShareableImageData: Transferable {
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.data
        }
    }
}

// MARK: - Share Multiple Items

struct ShareMultipleItemsExample: View {
    let items = [
        URL(string: "https://www.apple.com")!,
        URL(string: "https://developer.apple.com")!,
        URL(string: "https://swift.org")!
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share Multiple URLs")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { url in
                    Text("• \(url.host ?? "")")
                        .font(.caption)
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
            
            ShareLink(items: items) {
                Label("Share All Links", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Share Custom Data

struct ShareableArticle: Transferable {
    let title: String
    let content: String
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        // Share as URL
        ProxyRepresentation(exporting: \.url)
    }
    
    var formattedText: String {
        """
        \(title)
        
        \(content)
        
        Read more: \(url.absoluteString)
        """
    }
}

struct ShareCustomDataExample: View {
    let article = ShareableArticle(
        title: "SwiftUI Tips",
        content: "Learn the best practices for building apps with SwiftUI.",
        url: URL(string: "https://example.com/article")!
    )
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share Custom Data")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(article.content)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            
            ShareLink(
                item: article,
                preview: SharePreview(article.title, image: Image(systemName: "doc.text"))
            ) {
                Label("Share Article", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Share Rendered View

struct ShareRenderedViewExample: View {
    @State private var renderedImage: Image?
    @State private var renderedImageData: Data?
    
    var cardContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(.system(size: 40))
                .foregroundStyle(.yellow)
            
            Text("Achievement Unlocked!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("You completed all tasks")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .background(.blue.gradient)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share Rendered View")
                .font(.headline)
            
            cardContent
            
            HStack {
                Button("Render Image") {
                    renderImage()
                }
                .buttonStyle(.bordered)
                
                if let renderedImage, let renderedImageData {
                    let transferable = ShareableImageData(data: renderedImageData)
                    ShareLink(
                        item: transferable,
                        preview: SharePreview("Achievement Card", image: renderedImage)
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
    }
    
    @MainActor
    private func renderImage() {
        let renderer = ImageRenderer(content: cardContent)
        renderer.scale = UIScreen.main.scale
        
        if let uiImage = renderer.uiImage {
            renderedImageData = uiImage.pngData()
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

// MARK: - Share with Custom Label Styles

struct ShareLinkStylesExample: View {
    let shareURL = URL(string: "https://www.apple.com")!
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ShareLink Styles")
                .font(.headline)
            
            // Default style
            ShareLink(item: shareURL)
            
            // With label
            ShareLink(item: shareURL) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            // Custom styled
            ShareLink(item: shareURL) {
                HStack {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text("Share this link")
                            .font(.headline)
                        Text("apple.com")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
            }
            
            // Icon only
            ShareLink(item: shareURL) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                    .padding()
                    .background(Circle().fill(.blue))
                    .foregroundStyle(.white)
            }
        }
        .padding()
    }
}

// MARK: - Share in Toolbar

struct ShareInToolbarExample: View {
    let content = "This is the content I want to share from my app."
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(content)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
            }
            .padding()
            .navigationTitle("Document")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: content) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

// MARK: - Share Text File

struct ShareableTextFile: Transferable {
    let text: String
    let filename: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .plainText) { file in
            Data(file.text.utf8)
        }
        .suggestedFileName { file in
            file.filename
        }
    }
}

struct ShareTextFileExample: View {
    @State private var text = "Hello, this is the content of my text file.\n\nIt can have multiple lines."
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share as Text File")
                .font(.headline)
            
            TextEditor(text: $text)
                .frame(height: 150)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                }
            
            let file = ShareableTextFile(text: text, filename: "note.txt")
            ShareLink(
                item: file,
                preview: SharePreview("note.txt", image: Image(systemName: "doc.text"))
            ) {
                Label("Share as File", systemImage: "doc.text")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicShareLinkExample()
}

#Preview("With Metadata") {
    ShareLinkWithMetadataExample()
}

#Preview("With Preview") {
    ShareLinkPreviewExample()
}

#Preview("Share Image") {
    ShareImageExample()
}

#Preview("Multiple Items") {
    ShareMultipleItemsExample()
}

#Preview("Custom Data") {
    ShareCustomDataExample()
}

#Preview("Rendered View") {
    ShareRenderedViewExample()
}

#Preview("Styles") {
    ShareLinkStylesExample()
}

#Preview("In Toolbar") {
    ShareInToolbarExample()
}

#Preview("Text File") {
    ShareTextFileExample()
}
