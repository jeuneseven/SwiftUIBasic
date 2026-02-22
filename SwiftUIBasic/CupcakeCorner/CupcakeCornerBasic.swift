//
//  CupcakeCornerBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/11.
//

import SwiftUI
import CoreHaptics
import Observation

//struct CupcakeCornerBasic: View {
//    @State private var engine: CHHapticEngine?
//    @State private var counter = 0
//    
//    var body: some View {
//        Button("Tap Me", action: complexSuccess)
//            .onAppear(perform: prepareHaptics)
//        
//        Button("Tap count: \(counter)") {
//            counter += 1
//        }
//        .sensoryFeedback(.increase, trigger: counter)
//    }
//    
//    func prepareHaptics() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//
//        do {
//            engine = try CHHapticEngine()
//            try engine?.start()
//        } catch {
//            print("There was an error creating the engine: \(error.localizedDescription)")
//        }
//    }
//
//    func complexSuccess() {
//        // make sure that the device supports haptics
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//        var events = [CHHapticEvent]()
//
//        // create one intense, sharp tap
//        for i in stride(from: 0, to: 1, by: 0.1) {
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
//            events.append(event)
//        }
//
//        for i in stride(from: 0, to: 1, by: 0.1) {
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
//            events.append(event)
//        }
//
//        // convert those events into a pattern and play it immediately
//        do {
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            let player = try engine?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//        } catch {
//            print("Failed to play pattern: \(error.localizedDescription).")
//        }
//    }
//}

//@Observable
//class User: Codable {
//    // without enum CodingKeys print: {"_name":"Swift","_$observationRegistrar":{}}, as Observable will rewrite class so it can be monitored by SwiftUI
//    enum CodingKeys: String, CodingKey { // must name as CodingKeys and conform CodingKey
//    case _name = "name"
//    }
//    var name = "Swift"
//}
//
//struct CupcakeCornerBasic: View {
//    var body: some View {
//        Button("Encode Swift", action: encodeMethod)
//    }
//    
//    func encodeMethod() {
//        let data = try! JSONEncoder().encode(User())
//        let string = String(decoding: data, as: UTF8.self)
//        print(string)
//    }
//}

//struct CupcakeCornerBasic: View {
//    @State private var userName = ""
//    @State private var email = ""
//    
//    var disabledCondition: Bool {
//        userName.count < 5 || !email.contains("@")
//    }
//    
//    var body: some View {
//        Form {
//            Section {
//                TextField("Username", text: $userName)
//                TextField("Email", text: $email)
//                    .keyboardType(.emailAddress)
//                    .textContentType(.emailAddress) // keyboard will have @ .
//            }
//            
//            Section {
//                Button("Create Account") {}
//            }
//            .disabled(disabledCondition)
//        }
//    }
//}

//struct CupcakeCornerBasic: View {
//    var body: some View {
//        AsyncImage(url: URL(string: "https://hws.dev/img/404.png")) { phase in
//            if let image = phase.image {
//                image
//                    .resizable()
//                    .scaledToFit()
//            } else if phase.error != nil {
//                Text("There was an error loading the image.")
//            } else {
//                ProgressView()
//            }
//        }
//        .frame(width: 200, height: 200)
//        
//        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
//                image
//                .resizable() // can not modify the AsyncImage, as it is not downloaded yet
//                .scaledToFit()
//        } placeholder: {
//            ProgressView()
//        }
//        .frame(width: 200, height: 200)
//        
//        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
//    }
//}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Response: Codable {
    var results: [Result]
}

struct CupcakeCornerBasic: View {
    @State private var results = [Result]()
    var body: some View {
        List(results, id:\.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)

                Text(item.collectionName)
            }
        }
        .task {
            await loadData() // await must match to async, asleep might be happened
        }
    }
    
    func loadData() async { // async keyword means this function might go to sleep in order to complete this work
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else { return }
        do {
            // _ is stand for metadata, but it ignored
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func uploadData() async {
//        guard let encoded = try? JSONEncoder().encode(order) else {
//            print("Failed to encode order")
//            return
//        }
//        
//        let url = URL(string: "https://reqres.in/api/cupcakes")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        
//        do {
//            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//            let decodeOrder = try JSONDecoder().decode(Order.self, from: data)
//            
//            confirmationMessage = "Your order for \(decodeOrder.quantity)x\(Order.types[decodeOrder.type].lowercased()) cupcakes is on its way!"
//            showingConfirmation = true
//        } catch {
//            print("Check out failed")
//        }
//    }
}

//class UserModel: ObservableObject, Codable {
//    enum CodingKeys: String, CodingKey {
//    case name
//    }
//    @Published var name = "Swift"
//    // required means any class inherit from this class must implentation init
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//    
//    init() {}
//}
//
//struct CupcakeCornerBasic: View {
//    @StateObject var userModel = UserModel()
//    
//    var body: some View {
//        Button("Encode Swift", action: encodeMethod)
//    }
//    
//    func encodeMethod() {
//        guard let data = try? JSONEncoder().encode(UserModel()) else { return }
//        let string = String(decoding: data, as: UTF8.self)
//        print(string)
//    }
//}

#Preview {
    CupcakeCornerBasic()
}
