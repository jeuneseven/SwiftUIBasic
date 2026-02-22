//
//  InstafilterBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/12.
//

/**
    UIImage is standard image type for UIKit
    CGImage comes from Core Graphics, it is a two-dimensional array of pixels
    CIImage stores the information required to produce a picture, it is recipe, but it doesn't actually turn it into the actually pixels unless it's asked to
 */

import StoreKit
import SwiftUI
import CoreImage // manipulate image not draw, change existing image
import CoreImage.CIFilterBuiltins
import PhotosUI

struct InstafilterBasic: View {
    @Environment(\.requestReview) var requestReview
    var body: some View {
        Button("Leave a review") {
//            requestReview()
            callRequestReview()
        }
    }
    
//    @MainActor
    func callRequestReview() {
        Task { @MainActor in
            requestReview()
        }
    }
}

//struct InstafilterBasic: View {
//    var body: some View {
//        ShareLink(item: URL(string: "https://www.apple.com")!, subject: Text("Learn iOS"), message: Text("Check out"))
//        
//        ShareLink(item: URL(string: "https://www.apple.com")!) {
//            Label("Swift", systemImage: "swift")
//        }
//        
//        let example = Image(.example)
//        ShareLink(item: example, preview: SharePreview("Po", image:example)) {
//            Label("Click to share", systemImage: "cat")
//        }
//    }
//}

//struct InstafilterBasic: View {
//    @State private var pickerItem: PhotosPickerItem?
//    @State private var selectedImage: Image?
//    
//    @State private var pickerItems = [PhotosPickerItem]()
//    @State private var selectedImages = [Image]()
//    
//    var body: some View {
//        VStack {
//            PhotosPicker(selection: $pickerItem, matching: .images) {
//                Label("Select a picture", systemImage: "photo")
//            }
//            
//            selectedImage?
//                .resizable()
//                .scaledToFit()
//        }
//        .onChange(of: pickerItem) {
//            Task {
//                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
//            }
//        }
//        
//        Spacer()
//        
//        VStack {
//            PhotosPicker("Select pictures", selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)]))
//                ScrollView {
//                    ForEach(0..<selectedImages.count, id:\.self) { i in
//                        selectedImages[i]
//                            .resizable()
//                            .scaledToFit()
//                    }
//                }
//            }
//            .onChange(of: pickerItems) {
//                Task {
//                    selectedImages.removeAll()
//                    for item in pickerItems {
//                        if let loadImage = try await item.loadTransferable(type: Image.self) {
//                            selectedImages.append(loadImage)
//                        }
//                    }
//                }
//            }
//    }
//}

//struct InstafilterBasic: View {
//    var body: some View {
//        ContentUnavailableView("No snippets", systemImage: "swift", description: Text("no content yet"))
//        
//        ContentUnavailableView {
//            Label("No snippets", systemImage: "swift")
//        } description: {
//            Text("no content yet")
//        } actions: {
//            Button("create snippet") {
//                
//            }
//            .buttonStyle(.borderedProminent)
//        }
//    }
//}

//struct InstafilterBasic: View {
//    @State private var image: Image?
//    
//    var body: some View {
//        VStack {
//            image?
//                .resizable()
//                .scaledToFit()
//        }
//        .onAppear(perform: loadImg)
//    }
//    
//    func loadImg() {
//        let inputImage = UIImage(resource: .example)
//        let beginImage = CIImage(image: inputImage)
//
//        let context = CIContext()
//        let currentFilter = CIFilter.twirlDistortion()
//
//        currentFilter.inputImage = beginImage
//        let amount = 1.0
//        let inputKeys = currentFilter.inputKeys
//
//        if inputKeys.contains(kCIInputIntensityKey) {
//            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
//        }
//        if inputKeys.contains(kCIInputRadiusKey) {
//            currentFilter.setValue(amount * 100, forKey: kCIInputRadiusKey)
//        }
//        if inputKeys.contains(kCIInputScaleKey) {
//            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
//        }
//
//        currentFilter.radius = 300
//        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
//
//        guard let outputImage = currentFilter.outputImage else { return }
//        guard let cgImg = context.createCGImage(outputImage, from: outputImage.extent) else { return }
//
//        let uiImage = UIImage(cgImage: cgImg)
//        image = Image(uiImage: uiImage)
//    }
//}

//struct InstafilterBasic: View {
//    @State private var showingConfirmation = false
//    @State private var backgroundColor = Color.white
//    
//    var body: some View {
//        Button("Hello World!") {
//            showingConfirmation.toggle()
//        }
//        .frame(width: 300, height: 300)
//        .background(backgroundColor)
//        .confirmationDialog("Change Background", isPresented: $showingConfirmation) {
//            Button("Red") { backgroundColor = .red }
//            Button("Green") { backgroundColor = .green }
//            Button("Blue") { backgroundColor = .blue }
//            Button("Cancel", role: .cancel) {}
//        } message: {
//            Text("Select a new color")
//        }
//    }
//}

//struct InstafilterBasic: View {
//    // @State is a struct, it wrap our property inside it, contains a wrappedValue(get nonmutating set), nonmutating means when we change the value, it not change the struct
//    @State private var blurAmount = 0.0 {
//        didSet {
//            print("current blurAmount \(blurAmount)")
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            Text("Hello, world!")
//                .blur(radius: blurAmount)
//
//            // drage slider will not trigger didSet
//            Slider(value: $blurAmount, in: 0...10)
//            //onChange modifier will tell SwiftUI run a function of our choosing whenever a particular value changes and SwiftUI will automatically pass in both the Old and New value to whatever function you attach
////                .onChange(of: blurAmount) {
////                oldValue, newValue in
////                print("New value is \(newValue)")
////            }
//
//            Button("Random Blur") { // trigger didSet
//                blurAmount = Double.random(in: 0...10)
//            }
//        }// modifier in here also works
//        .onChange(of: blurAmount) {
//            oldValue, newValue in
//            print("New value is \(newValue)")
//        }
//        .padding()
//    }
//}

//struct InstafilterBasic: View {
//    @State private var image: Image?
//    @State private var inputImage: UIImage?
//    @State private var showingImagePicker = false
//    
//    var body: some View {
//        VStack {
//            image?
//                .resizable()
//                .scaledToFit()
//            
//            Button("Select Image") {
//                showingImagePicker = true
//            }
//            
//            Button("Save Image") {
//                guard let inputImage = inputImage else { return }
//                let imageSaver = ImageSaver()
//                
//                imageSaver.successHandler = {
//                    print("success!")
//                }
//                
//                imageSaver.errorHandler = {
//                    print($0.localizedDescription)
//                }
//                
//                imageSaver.writeToPhotoAlbum(image: inputImage)
//            }
//        }
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(image: $inputImage)
//        }
//        .onChange(of: inputImage) { _, _ in
//            loadImage()
//        }
//    }
//    
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
//}

#Preview {
    InstafilterBasic()
}
