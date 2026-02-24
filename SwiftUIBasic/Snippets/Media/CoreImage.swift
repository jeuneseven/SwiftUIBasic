//
//  CoreImage.swift
//  SwiftUIBasic
//
//  Core Image filters and image processing
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

// MARK: - Image Types Overview

/*
 UIImage  - Standard image type for UIKit
 CGImage  - Core Graphics, a 2D array of pixels
 CIImage  - Core Image, stores info to produce an image (a "recipe")
            Does not render pixels until asked
 */

// MARK: - Basic Filter Example

struct BasicFilterExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic Filter")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay {
                        Text("Select an image")
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
            loadAndFilter(item: newItem)
        }
    }
    
    private func loadAndFilter(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                applySepia()
            }
        }
    }
    
    private func applySepia() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        let filter = CIFilter.sepiaTone()
        
        filter.inputImage = ciImage
        filter.intensity = 0.8
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Multiple Filters

struct MultipleFiltersExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedFilter = 0
    
    let filterNames = ["Original", "Sepia", "Noir", "Chrome", "Fade", "Instant"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Filter Gallery")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 220)
                    .overlay {
                        Text("Select an image")
                            .foregroundStyle(.secondary)
                    }
            }
            
            if inputImage != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<filterNames.count, id: \.self) { index in
                            Button {
                                selectedFilter = index
                                applyFilter(index: index)
                            } label: {
                                Text(filterNames[index])
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == index ? .blue : .gray.opacity(0.2))
                                    .foregroundStyle(selectedFilter == index ? .white : .primary)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                selectedFilter = 0
                applyFilter(index: 0)
            }
        }
    }
    
    private func applyFilter(index: Int) {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        var outputImage: CIImage?
        
        switch index {
        case 0: // Original
            outputImage = ciImage
        case 1: // Sepia
            let filter = CIFilter.sepiaTone()
            filter.inputImage = ciImage
            filter.intensity = 0.8
            outputImage = filter.outputImage
        case 2: // Noir
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = ciImage
            outputImage = filter.outputImage
        case 3: // Chrome
            let filter = CIFilter.photoEffectChrome()
            filter.inputImage = ciImage
            outputImage = filter.outputImage
        case 4: // Fade
            let filter = CIFilter.photoEffectFade()
            filter.inputImage = ciImage
            outputImage = filter.outputImage
        case 5: // Instant
            let filter = CIFilter.photoEffectInstant()
            filter.inputImage = ciImage
            outputImage = filter.outputImage
        default:
            outputImage = ciImage
        }
        
        guard let output = outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Adjustable Filter

struct AdjustableFilterExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var brightness: Double = 0
    @State private var contrast: Double = 1
    @State private var saturation: Double = 1
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Adjustable Filter")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("Select an image")
                            .foregroundStyle(.secondary)
                    }
            }
            
            if inputImage != nil {
                VStack(spacing: 12) {
                    HStack {
                        Text("Brightness")
                            .frame(width: 80, alignment: .leading)
                        Slider(value: $brightness, in: -0.5...0.5)
                    }
                    
                    HStack {
                        Text("Contrast")
                            .frame(width: 80, alignment: .leading)
                        Slider(value: $contrast, in: 0.5...1.5)
                    }
                    
                    HStack {
                        Text("Saturation")
                            .frame(width: 80, alignment: .leading)
                        Slider(value: $saturation, in: 0...2)
                    }
                    
                    Button("Reset") {
                        brightness = 0
                        contrast = 1
                        saturation = 1
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                .onChange(of: brightness) { applyAdjustments() }
                .onChange(of: contrast) { applyAdjustments() }
                .onChange(of: saturation) { applyAdjustments() }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                brightness = 0
                contrast = 1
                saturation = 1
                applyAdjustments()
            }
        }
    }
    
    private func applyAdjustments() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        let filter = CIFilter.colorControls()
        
        filter.inputImage = ciImage
        filter.brightness = Float(brightness)
        filter.contrast = Float(contrast)
        filter.saturation = Float(saturation)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Blur Filter

struct BlurFilterExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var blurRadius: Double = 10
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Gaussian Blur")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 220)
                    .overlay {
                        Text("Select an image")
                            .foregroundStyle(.secondary)
                    }
            }
            
            if inputImage != nil {
                VStack {
                    Text("Blur Radius: \(Int(blurRadius))")
                    Slider(value: $blurRadius, in: 0...50)
                        .padding(.horizontal)
                }
                .onChange(of: blurRadius) { applyBlur() }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                blurRadius = 10
                applyBlur()
            }
        }
    }
    
    private func applyBlur() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        let filter = CIFilter.gaussianBlur()
        
        filter.inputImage = ciImage
        filter.radius = Float(blurRadius)
        
        // Clamp to extent to avoid edge artifacts
        let clampFilter = CIFilter.affineClamp()
        clampFilter.inputImage = ciImage
        clampFilter.transform = CGAffineTransform.identity
        
        filter.inputImage = clampFilter.outputImage
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Vignette Filter

struct VignetteFilterExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var intensity: Double = 1
    @State private var radius: Double = 1
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Vignette Effect")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("Select an image")
                            .foregroundStyle(.secondary)
                    }
            }
            
            if inputImage != nil {
                VStack(spacing: 12) {
                    HStack {
                        Text("Intensity")
                            .frame(width: 70, alignment: .leading)
                        Slider(value: $intensity, in: 0...2)
                    }
                    
                    HStack {
                        Text("Radius")
                            .frame(width: 70, alignment: .leading)
                        Slider(value: $radius, in: 0...2)
                    }
                }
                .padding(.horizontal)
                .onChange(of: intensity) { applyVignette() }
                .onChange(of: radius) { applyVignette() }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                intensity = 1
                radius = 1
                applyVignette()
            }
        }
    }
    
    private func applyVignette() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        let filter = CIFilter.vignette()
        
        filter.inputImage = ciImage
        filter.intensity = Float(intensity)
        filter.radius = Float(radius)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Twirl Distortion

struct TwirlDistortionExample: View {
    @State private var inputImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var twirlRadius: Double = 300
    @State private var angle: Double = 3
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Twirl Distortion")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("Select an image")
                            .foregroundStyle(.secondary)
                    }
            }
            
            if inputImage != nil {
                VStack(spacing: 12) {
                    HStack {
                        Text("Radius")
                            .frame(width: 60, alignment: .leading)
                        Slider(value: $twirlRadius, in: 50...500)
                    }
                    
                    HStack {
                        Text("Angle")
                            .frame(width: 60, alignment: .leading)
                        Slider(value: $angle, in: 0...10)
                    }
                }
                .padding(.horizontal)
                .onChange(of: twirlRadius) { applyTwirl() }
                .onChange(of: angle) { applyTwirl() }
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                inputImage = uiImage
                twirlRadius = 300
                angle = 3
                applyTwirl()
            }
        }
    }
    
    private func applyTwirl() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        let context = CIContext()
        let filter = CIFilter.twirlDistortion()
        
        filter.inputImage = ciImage
        filter.radius = Float(twirlRadius)
        filter.angle = Float(angle)
        filter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        filteredImage = Image(uiImage: uiImage)
    }
}

// MARK: - Filter Helper Extension

extension UIImage {
    /// Apply a CIFilter to the image
    func applyingFilter(_ filterName: String, parameters: [String: Any] = [:]) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        for (key, value) in parameters {
            filter?.setValue(value, forKey: key)
        }
        
        guard let outputImage = filter?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

struct FilterExtensionExample: View {
    @State private var originalImage: UIImage?
    @State private var filteredImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Filter Extension")
                .font(.headline)
            
            if let filteredImage {
                filteredImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            if originalImage != nil {
                HStack {
                    Button("Bloom") {
                        applyCustomFilter("CIBloom", params: [kCIInputRadiusKey: 10, kCIInputIntensityKey: 1])
                    }
                    
                    Button("Pixelate") {
                        applyCustomFilter("CIPixellate", params: [kCIInputScaleKey: 20])
                    }
                    
                    Button("Invert") {
                        applyCustomFilter("CIColorInvert", params: [:])
                    }
                }
                .buttonStyle(.bordered)
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            loadImage(item: newItem)
        }
    }
    
    private func loadImage(item: PhotosPickerItem?) {
        guard let item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data,
               let uiImage = UIImage(data: data) {
                originalImage = uiImage
                filteredImage = Image(uiImage: uiImage)
            }
        }
    }
    
    private func applyCustomFilter(_ name: String, params: [String: Any]) {
        guard let originalImage,
              let processed = originalImage.applyingFilter(name, parameters: params) else { return }
        
        filteredImage = Image(uiImage: processed)
    }
}

// MARK: - Preview

#Preview("Basic Filter") {
    BasicFilterExample()
}

#Preview("Multiple Filters") {
    MultipleFiltersExample()
}

#Preview("Adjustable Filter") {
    AdjustableFilterExample()
}

#Preview("Blur Filter") {
    BlurFilterExample()
}

#Preview("Vignette Filter") {
    VignetteFilterExample()
}

#Preview("Twirl Distortion") {
    TwirlDistortionExample()
}

#Preview("Filter Extension") {
    FilterExtensionExample()
}
