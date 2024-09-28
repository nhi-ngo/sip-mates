//
//  LocationMapViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import MapKit
import CloudKit
import SwiftUI

@MainActor final class LocationMapViewModel: ObservableObject {
    
    @Published var isShowingDetailView = false
    @Published var fetchError: SipMatesError?
    @Published var isShowingAlert = false
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
    func getLocations(for locationManager: LocationManager) {
        Task {
            do {
                locationManager.locations = try await CloudKitManager.shared.getLocations()
            } catch {
                isShowingAlert = true
                fetchError = .unableToGetLocations
            }
        }
    }
}
