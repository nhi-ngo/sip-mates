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
    
    @Observable
    final class LocationMapViewModel: NSObject, CLLocationManagerDelegate {
        
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        var isShowingDetailView = false
        var alertItem: AlertItem?
        var cameraPosition: MapCameraPosition = .region(.init(center: CLLocationCoordinate2D(latitude: 37.331516,
                                                                                              longitude: -121.891054),
                                                               latitudinalMeters: 1200,
                                                               longitudinalMeters: 1200))
        
        let deviceLocationManager = CLLocationManager()
        
        override init() {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        func requestAllowOnceLocationPermission() {
            deviceLocationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            
            withAnimation {
                cameraPosition = .region(.init(center: currentLocation.coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did Fail With Error")
        }
           
        @MainActor
        func getLocations(for locationManager: LocationManager) {
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
        @MainActor
        func getCheckedInCounts() {
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                } catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
    }
}


