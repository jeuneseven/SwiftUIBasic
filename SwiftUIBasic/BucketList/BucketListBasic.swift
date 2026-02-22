//
//  BucketListBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/8.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct BucketListBasic: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    // backup e.g alert
                    isUnlocked = false
                }
            }
        } else {
            print("no biometrics")
        }
    }
}

//struct BucketListBasic: View {
//    var body: some View {
//        VStack {
//            MapReader { proxy in
//                Map()
//                    .onTapGesture { position in
//                        if let corrdinate = proxy.convert(position, from: .local) {
//                            print(corrdinate)
//                        }
//                    }
//            }
//        }
//    }
//}

//struct Location: Identifiable, Equatable {
//    let id = UUID()
//    var name: String
//    var coordinate: CLLocationCoordinate2D
//    
//    // Swift auto synthesize ==
//    static func ==(lhs: Location, rhs: Location) -> Bool {
//        lhs.id == rhs.id
//    }
//}
//
//struct BucketListBasic: View {
//    let locations = [
//        Location(name: "Taipei", coordinate: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654)),
//        Location(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
//    ]
//    
//    var body: some View {
//        VStack {
//            Map {
//                ForEach(locations) { location in
//                    //                    Marker(location.name, coordinate: location.coordinate)
//                    Annotation(location.name, coordinate: location.coordinate) {
//                        Text(location.name)
//                            .font(.headline)
//                            .padding()
//                            .background(.blue.gradient)
//                            .foregroundStyle(.white)
//                            .clipShape(.capsule)
//                    }
//                    .annotationTitles(.hidden)
//                }
//            }
//        }
//    }
//}
    
//struct BucketListBasic: View {
//    @State private var position = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645),
//            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//    )
//    
//    var body: some View {
//        Map(position: $position)
//            .mapStyle(.hybrid(elevation: .realistic))
//            .onMapCameraChange(frequency: .continuous) { context in
//                print(context.region)
//            }
//
//        HStack(spacing: 50) {
//            Button("Taipei") {
//                position = MapCameraPosition.region(
//                    MKCoordinateRegion(
//                        center: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654),
//                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
//            }
//
//            Button("Tokyo") {
//                position = MapCameraPosition.region(
//                    MKCoordinateRegion(
//                        center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
//                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
//            }
//
//            Button("London") {
//                position = MapCameraPosition.region(
//                    MKCoordinateRegion(
//                        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
//                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
//            }
//        }
//    }
//}

//struct LoadingView: View {
//    var body: some View {
//        Text("Loading...")
//    }
//}
//
//struct FailedView: View {
//    var body: some View {
//        Text("Failed to load.")
//    }
//}
//
//struct SucceedView: View {
//    var body: some View {
//        Text("Succeed.")
//    }
//}
//
//struct BucketListBasic: View {
//    enum LoadState {
//        case loading, succeed, failed
//    }
//    
//    @State private var loadingState = LoadState.succeed
//    
//    var body: some View {
//        switch loadingState {
//        case .loading:
//            LoadingView()
//        case .succeed:
//            SucceedView()
//        case .failed:
//            FailedView()
//        }
//    }
//}

//extension FileManager {
//    @discardableResult
//    func write(_ data: Data, fileName: String?, path: FileManager.SearchPathDirectory = .documentDirectory, options: Data.WritingOptions = [.atomic, .completeFileProtection]) throws -> URL {
//        guard let urlPath = fileName else { return URL(string:"")! }
//
//        let url = try self.url(for: path, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(urlPath)
//        try data.write(to: url)
//        return url
//    }
//
//    @discardableResult
//    func read(fileName: String?, directory: FileManager.SearchPathDirectory = .documentDirectory, encoding: String.Encoding = .utf8) throws -> String {
//        guard let fileName = fileName else { return "" }
//        let url = try self.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: false)
//                    .appendingPathComponent(fileName)
//        return try String(contentsOf: url, encoding: encoding)
//    }
//}
//
//struct BucketListBasic: View {
//    var body: some View {
//        Button("Read and Write") {
//            let url = "message.txt"
//            try? FileManager.default.write(Data("Test String".utf8), fileName: url)
//            let input = try? FileManager.default.read(fileName: url)
//            print(input ?? "")
//        }
//    }
//}

//struct BucketListBasic: View {
//    var body: some View {
//        Button("Read and write") {
//            let data = Data("Test message".utf8)
//            let url = URL.documentsDirectory.appending(path: "message.txt")
//            
//            do {
//                /**
//                 .atomic:
//                 Ensures the file is written to a temporary location first.
//
//                 Once writing finishes, the temporary file instantly replaces the old one.
//
//                 Guarantees the file is either fully written or not changed at all (no “half-written” files).
//                 
//                 .completeFileProtection:
//                 Encrypts the file and makes it accessible only when the device is unlocked.
//
//                 While the device is locked, the file cannot be read or written.
//
//                 Provides the highest level of file security on iOS.
//                 */
//                try data.write(to: url, options: [.atomic, .completeFileProtection])
//                let input = try String(contentsOf: url, encoding: .utf8)
//                print(input)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}

//struct BucketListOption: Identifiable, Comparable {
//    var id = UUID()
//    var name: String
//    // operator overloading
//    static func <(lhs: BucketListOption, rhs: BucketListOption) -> Bool {
//        lhs.name < rhs.name
//    }
//}
//
//struct BucketListBasic: View {
//    let options = [
//        BucketListOption(name: "G"),
//        BucketListOption(name: "A"),
//        BucketListOption(name: "V"),
//        BucketListOption(name: "D")
//    ].sorted()
////    {
////        $0.name < $1.name
////    }
//
//    var body: some View {
//        List(options) { option in
//            Text(option.name)
//        }
//    }
//}

//struct BucketListBasic: View {
//    let numbers = [23, 34, 45, 7, 6, 4].sorted().reversed()
//    var body: some View {
//        List(numbers, id:\.self) {
//            Text(String($0))
//        }
//    }
//}

#Preview {
    BucketListBasic()
}
