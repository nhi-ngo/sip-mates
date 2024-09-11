//
//  LocationMapViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import MapKit
import CloudKit
import SwiftUI


@MainActor final class LocationMapViewModel: NSObject, ObservableObject {
    
    @Published var isShowingOnboardingView = false
    @Published var fetchError: SipMatesError?
    @Published var isShowingAlert = false
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var deviceLocationManager: CLLocationManager?
    let kHasSeenOnboardingView = "hasSeenOnboardingView"
    
    var hasSeenOnboardingView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardingView)
    }
    
    func runStartupChecks() {
        if !hasSeenOnboardingView {
            isShowingOnboardingView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardingView)
        } else {
            checkIfLocationServicesIsEnabled()
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            deviceLocationManager = CLLocationManager()
            deviceLocationManager!.delegate = self
        } else {
            isShowingAlert = true
            fetchError = .locationDisabled
        }
    }
    
    private func checkLocationAuthorization() {
        guard let deviceLocationManager = deviceLocationManager else { return }
        
        switch deviceLocationManager.authorizationStatus {
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            isShowingAlert = true
            fetchError = .locationRestricted
        case .denied:
            isShowingAlert = true
            fetchError = .locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break

        @unknown default:
            break
        }
    }
    
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

extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
