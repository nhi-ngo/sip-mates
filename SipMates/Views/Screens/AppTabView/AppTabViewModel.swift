//
//  AppTabViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/28/24.
//

import SwiftUI
//import MapKit
//import CloudKit
import CoreLocation

extension AppTabView {
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var isShowingOnboardingView = false
        @Published var fetchError: SipMatesError?
        @Published var isShowingAlert = false
        @AppStorage("hasSeenOnboardingView") var hasSeenOnboardingView = false {
            didSet { isShowingOnboardingView = true }
        }
        
        var deviceLocationManager: CLLocationManager?
        
        func runStartupChecks() {
            if !hasSeenOnboardingView {
                hasSeenOnboardingView = true
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
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}


