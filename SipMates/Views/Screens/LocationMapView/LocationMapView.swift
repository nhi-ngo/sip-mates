//
//  LocationMapView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject  private var viewModel = LocationMapViewModel()
    @State private var fetchError: SipMatesError = .unableToGetLocations
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(viewModel.region)) {
                ForEach(locationManager.locations) { location in
                    Marker(location.name, coordinate: location.location.coordinate)
                        .tint(.brandPrimary)
                }
            }
            .task {
                if locationManager.locations.isEmpty {
                    do {
                        viewModel.getLocations(for: locationManager)
                    } catch SipMatesError.unableToGetLocations {
                        fetchError = .unableToGetLocations
                    }
                }
            }
            .alert(isPresented: $viewModel.isShowingAlert, error: fetchError) { fetchError in
                // Action - OK button to dismiss
            } message: { fetchError in
                Text(fetchError.failureReason)
            }
        }
    }
}

#Preview {
    LocationMapView()
        .environmentObject(LocationManager())
}
