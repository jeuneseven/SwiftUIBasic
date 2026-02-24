//
//  MapBasics.swift
//  SwiftUIBasic
//
//  MapKit integration with SwiftUI
//

import SwiftUI
import MapKit

// MARK: - Map Location Model

struct MapLocation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MapLocation, rhs: MapLocation) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Basic Map

struct BasicMapExample: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Basic Map")
                .font(.headline)
                .padding()
            
            Map()
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map with Initial Position

struct MapPositionExample: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map with Position")
                .font(.headline)
                .padding()
            
            Map(position: $position)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map Styles

struct MapStylesExample: View {
    @State private var selectedStyle = 0
    
    var mapStyle: MapStyle {
        switch selectedStyle {
        case 0: return .standard
        case 1: return .imagery
        case 2: return .hybrid
        case 3: return .standard(elevation: .realistic)
        default: return .standard
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map Styles")
                .font(.headline)
                .padding(.top)
            
            Picker("Style", selection: $selectedStyle) {
                Text("Standard").tag(0)
                Text("Satellite").tag(1)
                Text("Hybrid").tag(2)
                Text("3D").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom)
            
            Map()
                .mapStyle(mapStyle)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map with Markers

struct MapMarkersExample: View {
    let locations = [
        MapLocation(name: "Sky Tower", coordinate: CLLocationCoordinate2D(latitude: -36.8485, longitude: 174.7633)),
        MapLocation(name: "Auckland Museum", coordinate: CLLocationCoordinate2D(latitude: -36.8600, longitude: 174.7778)),
        MapLocation(name: "Viaduct Harbour", coordinate: CLLocationCoordinate2D(latitude: -36.8436, longitude: 174.7617))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map with Markers")
                .font(.headline)
                .padding()
            
            Map {
                ForEach(locations) { location in
                    Marker(location.name, coordinate: location.coordinate)
                        .tint(.red)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map with Annotations

struct MapAnnotationsExample: View {
    let locations = [
        MapLocation(name: "Cafe", coordinate: CLLocationCoordinate2D(latitude: -36.8485, longitude: 174.7633)),
        MapLocation(name: "Park", coordinate: CLLocationCoordinate2D(latitude: -36.8550, longitude: 174.7700)),
        MapLocation(name: "Shop", coordinate: CLLocationCoordinate2D(latitude: -36.8450, longitude: 174.7580))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Custom Annotations")
                .font(.headline)
                .padding()
            
            Map {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: iconForLocation(location.name))
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.blue)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func iconForLocation(_ name: String) -> String {
        switch name {
        case "Cafe": return "cup.and.saucer.fill"
        case "Park": return "leaf.fill"
        case "Shop": return "bag.fill"
        default: return "mappin"
        }
    }
}

// MARK: - Map Camera Controls

struct MapCameraControlsExample: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    )
    
    let cities = [
        ("Auckland", CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645)),
        ("Wellington", CLLocationCoordinate2D(latitude: -41.2866, longitude: 174.7756)),
        ("Christchurch", CLLocationCoordinate2D(latitude: -43.5321, longitude: 172.6362))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Camera Controls")
                .font(.headline)
                .padding(.top)
            
            HStack {
                ForEach(cities, id: \.0) { city in
                    Button(city.0) {
                        withAnimation {
                            position = .region(MKCoordinateRegion(
                                center: city.1,
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            ))
                        }
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                }
            }
            .padding(.bottom)
            
            Map(position: $position)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map with Tap to Add Marker

struct MapTapToAddExample: View {
    @State private var markers: [MapLocation] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Tap to Add Markers")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear") {
                    markers.removeAll()
                }
                .font(.caption)
            }
            .padding()
            
            MapReader { proxy in
                Map {
                    ForEach(markers) { marker in
                        Marker(marker.name, coordinate: marker.coordinate)
                            .tint(.red)
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        let newMarker = MapLocation(
                            name: "Pin \(markers.count + 1)",
                            coordinate: coordinate
                        )
                        markers.append(newMarker)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            Text("Markers: \(markers.count)")
                .font(.caption)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Map with Route/Polyline

struct MapRouteExample: View {
    let routeCoordinates = [
        CLLocationCoordinate2D(latitude: -36.8485, longitude: 174.7633),
        CLLocationCoordinate2D(latitude: -36.8500, longitude: 174.7680),
        CLLocationCoordinate2D(latitude: -36.8550, longitude: 174.7700),
        CLLocationCoordinate2D(latitude: -36.8600, longitude: 174.7750)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map with Route")
                .font(.headline)
                .padding()
            
            Map {
                Marker("Start", coordinate: routeCoordinates.first!)
                    .tint(.green)
                
                Marker("End", coordinate: routeCoordinates.last!)
                    .tint(.red)
                
                MapPolyline(coordinates: routeCoordinates)
                    .stroke(.blue, lineWidth: 4)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map with Circle Overlay

struct MapCircleOverlayExample: View {
    let center = CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645)
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Circle Overlay")
                .font(.headline)
                .padding()
            
            Map {
                Marker("Center", coordinate: center)
                
                MapCircle(center: center, radius: 1000)
                    .foregroundStyle(.blue.opacity(0.3))
                    .stroke(.blue, lineWidth: 2)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map Camera Change Observer

struct MapCameraObserverExample: View {
    @State private var position = MapCameraPosition.automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Camera Observer")
                .font(.headline)
                .padding(.top)
            
            if let region = visibleRegion {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Center: \(region.center.latitude, specifier: "%.4f"), \(region.center.longitude, specifier: "%.4f")")
                    Text("Span: \(region.span.latitudeDelta, specifier: "%.4f")° × \(region.span.longitudeDelta, specifier: "%.4f")°")
                }
                .font(.caption)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Map(position: $position)
                .onMapCameraChange(frequency: .continuous) { context in
                    visibleRegion = context.region
                }
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Map Controls

struct MapControlsExample: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map Controls")
                .font(.headline)
                .padding()
            
            Map(position: $position) {
                Marker("Auckland", coordinate: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645))
            }
            .mapControls {
                MapCompass()
                MapScaleView()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Preview

#Preview("Basic Map") {
    BasicMapExample()
}

#Preview("Map Position") {
    MapPositionExample()
}

#Preview("Map Styles") {
    MapStylesExample()
}

#Preview("Markers") {
    MapMarkersExample()
}

#Preview("Annotations") {
    MapAnnotationsExample()
}

#Preview("Camera Controls") {
    MapCameraControlsExample()
}

#Preview("Tap to Add") {
    MapTapToAddExample()
}

#Preview("Route") {
    MapRouteExample()
}

#Preview("Circle Overlay") {
    MapCircleOverlayExample()
}

#Preview("Camera Observer") {
    MapCameraObserverExample()
}

#Preview("Map Controls") {
    MapControlsExample()
}
