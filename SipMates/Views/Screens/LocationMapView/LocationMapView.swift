//
//  LocationMapView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @State private var viewModel = LocationMapViewModel()
    
    var body: some View {
        ZStack {
            Map(initialPosition: viewModel.cameraPosition) {
                ForEach(locationManager.locations) { location in
                    Annotation(location.name, coordinate: location.location.coordinate) {
                        SMAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
                            .onTapGesture {
                                locationManager.selectedLocation = location
                                viewModel.isShowingDetailView = true
                            }
                    }
                    .annotationTitles(.hidden)
                }
                
                UserAnnotation()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationStack {
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar { Button("Dismiss") { viewModel.isShowingDetailView = false }}
            }
        }
        .overlay(alignment: .bottomLeading) {
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.red)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .task {
            if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
            viewModel.getCheckedInCounts()
        }
    }
}


#Preview {
    LocationMapView().environmentObject(LocationManager())
}
