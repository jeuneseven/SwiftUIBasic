//
//  PhotosPicker.swift
//  SwiftUIBasic
//
//  PhotosPicker for selecting images from photo library
//

import SwiftUI
import PhotosUI

// MARK: - Basic PhotosPicker

struct BasicPhotosPickerExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic PhotosPicker")
                .font(.headline)
            
            // Display selected image
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
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
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            // Load the image when selection changes
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}

// MARK: - PhotosPicker with Image Transfer

struct PhotosPickerTransferExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Using Image.self Transferable")
                .font(.headline)
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                ContentUnavailableView("No Photo", systemImage: "photo", description: Text("Select a photo to display"))
            }
            
            PhotosPicker("Select Photo", selection: $selectedItem, matching: .images)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                // Directly load as Image (simpler but less control)
                selectedImage = try? await newItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

// MARK: - Multiple Photo Selection

struct MultiplePhotosPickerExample: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                if selectedImages.isEmpty {
                    ContentUnavailableView("No Photos", systemImage: "photo.on.rectangle.angled", description: Text("Select multiple photos"))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                selectedImages[index]
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 120)
                                    .clipped()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Photos (\(selectedImages.count))")
            .toolbar {
                // maxSelectionCount limits how many can be selected
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 9, matching: .images) {
                    Label("Select", systemImage: "plus")
                }
            }
        }
        .onChange(of: selectedItems) { _, newItems in
            Task {
                selectedImages.removeAll()
                
                for item in newItems {
                    if let image = try? await item.loadTransferable(type: Image.self) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
}

// MARK: - PhotosPicker with Filters

struct PhotosPickerFilterExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var filterType = 0
    
    var currentFilter: PHPickerFilter {
        switch filterType {
        case 0: return .images
        case 1: return .screenshots
        case 2: return .livePhotos
        case 3: return .videos
        case 4: return .any(of: [.images, .videos])
        default: return .images
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("PhotosPicker Filters")
                .font(.headline)
            
            Picker("Filter", selection: $filterType) {
                Text("Images").tag(0)
                Text("Screenshots").tag(1)
                Text("Live Photos").tag(2)
                Text("Videos").tag(3)
                Text("Images & Videos").tag(4)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
            }
            
            PhotosPicker(selection: $selectedItem, matching: currentFilter) {
                Label("Select", systemImage: "photo.badge.plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                selectedImage = try? await newItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

// MARK: - PhotosPicker Excluding Screenshots

struct PhotosPickerExcludeExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Exclude Screenshots")
                .font(.headline)
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            // .not() filter excludes certain types
            PhotosPicker(
                selection: $selectedItem,
                matching: .any(of: [.images, .not(.screenshots)])
            ) {
                Label("Select (No Screenshots)", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                selectedImage = try? await newItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

// MARK: - PhotosPicker with UIImage Output

struct PhotosPickerUIImageExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var imageSize: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Get UIImage")
                .font(.headline)
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
                
                Text(imageSize)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    uiImage = image
                    imageSize = "Size: \(Int(image.size.width)) x \(Int(image.size.height))"
                }
            }
        }
    }
}

// MARK: - PhotosPicker Inline Style

struct PhotosPickerInlineExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Inline Picker Style")
                .font(.headline)
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            // Inline style shows picker directly in view
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue.opacity(0.1))
                        .frame(height: 100)
                    
                    VStack {
                        Image(systemName: "photo.badge.plus")
                            .font(.largeTitle)
                        Text("Tap to select")
                            .font(.caption)
                    }
                    .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                selectedImage = try? await newItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

// MARK: - PhotosPicker with Loading State

struct PhotosPickerLoadingExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("With Loading State")
                .font(.headline)
            
            ZStack {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(.rect(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 200)
                }
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                isLoading = true
                selectedImage = try? await newItem?.loadTransferable(type: Image.self)
                isLoading = false
            }
        }
    }
}

// MARK: - Profile Photo Picker

struct ProfilePhotoPickerExample: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Photo")
                .font(.headline)
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 3)
                        }
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "camera.fill")
                            .padding(8)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .offset(x: 5, y: 5)
                    }
                }
            }
            
            Text("Tap to change photo")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                profileImage = try? await newItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicPhotosPickerExample()
}

#Preview("Image Transfer") {
    PhotosPickerTransferExample()
}

#Preview("Multiple Selection") {
    MultiplePhotosPickerExample()
}

#Preview("Filters") {
    PhotosPickerFilterExample()
}

#Preview("Exclude Screenshots") {
    PhotosPickerExcludeExample()
}

#Preview("UIImage Output") {
    PhotosPickerUIImageExample()
}

#Preview("Inline Style") {
    PhotosPickerInlineExample()
}

#Preview("Loading State") {
    PhotosPickerLoadingExample()
}

#Preview("Profile Photo") {
    ProfilePhotoPickerExample()
}
