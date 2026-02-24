//
//  ImageSaver.swift
//  SwiftUIBasic
//
//  Save images to photo library
//

import SwiftUI
import PhotosUI

// Avoid naming conflicts with other Task types in the project
private typealias AsyncTask = Task

// MARK: - ImageSaver Class

/// Helper class to save UIImage to photo library
/// Requires NSPhotoLibraryAddUsageDescription in Info.plist
class ImageSaver: NSObject {
    var onSuccess: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func saveToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            onError?(error)
        } else {
            onSuccess?()
        }
    }
}

// MARK: - Basic Save Example

struct BasicImageSaveExample: View {
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Save Image to Photos")
                .font(.headline)
            
            Image(systemName: "photo.artframe")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
                .frame(width: 200, height: 200)
                .background(.blue.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
            
            Button("Save to Photo Library") {
                saveImage()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Requires photo library permission")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveImage() {
        // Create a sample image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        let image = renderer.image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 200, height: 200))
            
            let text = "Sample"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (200 - textSize.width) / 2,
                y: (200 - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        let imageSaver = ImageSaver()
        
        imageSaver.onSuccess = {
            alertTitle = "Success"
            alertMessage = "Image saved to photo library"
            showingAlert = true
        }
        
        imageSaver.onError = { error in
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showingAlert = true
        }
        
        imageSaver.saveToPhotoAlbum(image: image)
    }
}

// MARK: - Save Selected Photo

struct SaveSelectedPhotoExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select & Save Photo")
                .font(.headline)
            
            if let selectedUIImage {
                Image(uiImage: selectedUIImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
                
                Button("Save Copy to Library") {
                    saveImage(selectedUIImage)
                }
                .buttonStyle(.borderedProminent)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("No image selected")
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
        .alert("Save Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data, let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                }
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
        }
    }
    
    private func saveImage(_ image: UIImage) {
        let imageSaver = ImageSaver()
        
        imageSaver.onSuccess = {
            alertMessage = "Image saved successfully!"
            showingAlert = true
        }
        
        imageSaver.onError = { error in
            alertMessage = "Failed to save: \(error.localizedDescription)"
            showingAlert = true
        }
        
        imageSaver.saveToPhotoAlbum(image: image)
    }
}

// MARK: - Save Rendered View

struct SaveRenderedViewExample: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var backgroundColor = Color.blue
    @State private var text = "Hello!"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Save Rendered View")
                .font(.headline)
            
            // The view to render and save
            cardView
                .frame(width: 280, height: 180)
            
            HStack {
                Button("Blue") { backgroundColor = .blue }
                Button("Purple") { backgroundColor = .purple }
                Button("Green") { backgroundColor = .green }
            }
            .buttonStyle(.bordered)
            
            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
            
            Button("Save as Image") {
                saveViewAsImage()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert("Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private var cardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor.gradient)
            
            VStack {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .foregroundStyle(.white)
        }
    }
    
    @MainActor
    private func saveViewAsImage() {
        // Render the SwiftUI view to UIImage
        let renderer = ImageRenderer(content: cardView.frame(width: 280, height: 180))
        renderer.scale = UIScreen.main.scale
        
        guard let uiImage = renderer.uiImage else {
            alertMessage = "Failed to render image"
            showingAlert = true
            return
        }
        
        let imageSaver = ImageSaver()
        
        imageSaver.onSuccess = {
            alertMessage = "Card saved to photo library!"
            showingAlert = true
        }
        
        imageSaver.onError = { error in
            alertMessage = "Failed: \(error.localizedDescription)"
            showingAlert = true
        }
        
        imageSaver.saveToPhotoAlbum(image: uiImage)
    }
}

// MARK: - Save with Processing

struct SaveWithProcessingExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var originalImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Process & Save")
                .font(.headline)
            
            HStack(spacing: 12) {
                // Original
                VStack {
                    Text("Original")
                        .font(.caption)
                    
                    if let originalImage {
                        Image(uiImage: originalImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .clipShape(.rect(cornerRadius: 8))
                    } else {
                        placeholderView
                    }
                }
                
                // Processed
                VStack {
                    Text("Grayscale")
                        .font(.caption)
                    
                    if let processedImage {
                        Image(uiImage: processedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .clipShape(.rect(cornerRadius: 8))
                    } else {
                        placeholderView
                    }
                }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.bordered)
            
            if processedImage != nil {
                Button("Save Processed Image") {
                    if let processedImage {
                        saveImage(processedImage)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            if isProcessing {
                ProgressView("Processing...")
            }
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            processImage(from: newItem)
        }
        .alert("Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 120, height: 120)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            }
    }
    
    private func processImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        
        isProcessing = true
        
        item.loadTransferable(type: Data.self) { result in
            isProcessing = false
            
            switch result {
            case .success(let data):
                if let data, let uiImage = UIImage(data: data) {
                    originalImage = uiImage
                    processedImage = applyGrayscale(to: uiImage)
                }
            case .failure(let error):
                print("Failed to load: \(error)")
            }
        }
    }
    
    private func applyGrayscale(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func saveImage(_ image: UIImage) {
        let imageSaver = ImageSaver()
        
        imageSaver.onSuccess = {
            alertMessage = "Processed image saved!"
            showingAlert = true
        }
        
        imageSaver.onError = { error in
            alertMessage = "Failed: \(error.localizedDescription)"
            showingAlert = true
        }
        
        imageSaver.saveToPhotoAlbum(image: image)
    }
}

// MARK: - Async Image Saver

actor AsyncImageSaver {
    enum SaveError: Error, LocalizedError {
        case saveFailed(Error)
        case noImage
        
        var errorDescription: String? {
            switch self {
            case .saveFailed(let error):
                return "Save failed: \(error.localizedDescription)"
            case .noImage:
                return "No image to save"
            }
        }
    }
    
    func save(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let saver = ImageSaver()
            
            saver.onSuccess = {
                continuation.resume()
            }
            
            saver.onError = { error in
                continuation.resume(throwing: SaveError.saveFailed(error))
            }
            
            DispatchQueue.main.async {
                saver.saveToPhotoAlbum(image: image)
            }
        }
    }
}

struct AsyncImageSaverExample: View {
    @State private var isSaving = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Async Image Saver")
                .font(.headline)
            
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Button("Save Test Image") {
                saveTestImage()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSaving)
            
            if isSaving {
                ProgressView("Saving...")
            }
        }
        .alert("Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveTestImage() {
        // Create test image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let image = renderer.image { context in
            UIColor.systemGreen.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        isSaving = true
        
        let saver = AsyncImageSaver()
        
        AsyncTask {
            do {
                try await saver.save(image)
                alertMessage = "Image saved successfully!"
            } catch {
                alertMessage = error.localizedDescription
            }
            
            isSaving = false
            showingAlert = true
        }
    }
}

// MARK: - Preview

#Preview("Basic Save") {
    BasicImageSaveExample()
}

#Preview("Save Selected Photo") {
    SaveSelectedPhotoExample()
}

#Preview("Save Rendered View") {
    SaveRenderedViewExample()
}

#Preview("Process & Save") {
    SaveWithProcessingExample()
}

#Preview("Async Saver") {
    AsyncImageSaverExample()
}
