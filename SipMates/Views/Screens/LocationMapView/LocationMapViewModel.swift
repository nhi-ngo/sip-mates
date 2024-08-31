//
//  LocationMapViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView {
    
    @MainActor final class LocationMapViewModel: ObservableObject {
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        @Published var locations: [SMLocation] = []
        
        func getLocations() {
            Task {
                do {
                    locations = try await CloudKitManager.shared.getLocations()
                } catch {
                    throw SipMatesError.unableToGetLocations
                }
            }
        }
    }
}
