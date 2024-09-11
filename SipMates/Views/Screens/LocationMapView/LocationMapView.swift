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
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(viewModel.region)) {
                UserAnnotation().tint(Color(.red))
                ForEach(locationManager.locations) { location in
                    Marker(location.name, coordinate: location.location.coordinate)
                        .tint(.brandPrimary)
                }
            }
            .task {
                viewModel.checkIfLocationServicesIsEnabled()
                if locationManager.locations.isEmpty {
                    do {
                        viewModel.getLocations(for: locationManager)
                    } catch SipMatesError.unableToGetLocations {
                        viewModel.fetchError = .unableToGetLocations
                    }
                }
            }
            .alert(isPresented: $viewModel.isShowingAlert, error: viewModel.fetchError) { fetchError in
                switch fetchError {
                case .locationDenied, .locationDisabled:
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    Button("Cancel", role: .cancel) {
                        // OK button to dismiss
                    }
                case .unableToGetLocations, .locationRestricted:
                    EmptyView()
                }
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
