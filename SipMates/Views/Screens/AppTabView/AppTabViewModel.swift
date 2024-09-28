//
//  AppTabViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/28/24.
//

import SwiftUI
import MapKit
import CloudKit

final class AppTabViewModel: NSObject, ObservableObject {
    
    @Published var isShowingOnboardingView = false
    @Published var fetchError: SipMatesError?
    @Published var isShowingAlert = false
    
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
