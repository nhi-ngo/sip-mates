//
//  LocationMapView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(region))
                .ignoresSafeArea()
                .onMapCameraChange(frequency: .continuous) {
                    print($0.region)
                }
        }
    }
}

#Preview {
    LocationMapView()
}
