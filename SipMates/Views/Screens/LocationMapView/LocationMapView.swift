//
//  LocationMapView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @StateObject var viewModel = LocationMapViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var isShowingAlert = false
    @State private var fetchError: SipMatesError = .unableToGetLocations
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(region))
                .ignoresSafeArea()
                .onMapCameraChange(frequency: .continuous) {
                    //                    print($0.region)
                }
        }
        .task {
            do {
                viewModel.getLocations()
            } catch SipMatesError.unableToGetLocations {
                fetchError = .unableToGetLocations
                isShowingAlert = true
            }
        }
        .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
            // Action - OK button to dismiss
        } message: { fetchError in
            Text(fetchError.failureReason)
        }
    }
}

#Preview {
    LocationMapView()
}
